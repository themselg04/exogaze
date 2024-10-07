import json  # Módulo para trabajar con archivos JSON.
from astroquery.gaia import Gaia  # Módulo para hacer consultas a la base de datos de Gaia.
from astropy import units as u  # Módulo para manejar unidades astronómicas como grados y parsecs.
from astropy.coordinates import SkyCoord  # Clase para representar y transformar coordenadas astronómicas.
import numpy as np  # Biblioteca para operaciones numéricas.


#abrir archivo json
with open('exoplanetas.json', 'r') as archivo:
    datos = json.load(archivo)

def buscar_planeta(datos, buscado):
    for elemento in datos:
        if elemento['nombre'] == buscado:
            return elemento
    return None

print("\n-------------------------------- BUSCADOR DE ESTRELLAS -------------------------\n")


planeta_buscar = input("Elige un planeta: ")
planeta = buscar_planeta(datos, planeta_buscar)

if planeta:
    
    ar= planeta['ascencion_recta']
    dec = planeta['dec']
    dist = planeta['distancia']
    
    # Función que devuelve los datos de un exoplaneta con coordenadas fijas (ra, dec) y distancia.
    def get_static_exoplanet_data():
        return {
        'ra':   ar * u.deg,  # Ascensión recta en grados.
        'dec':  dec * u.deg,  # Declinación en grados.
        'distance': dist * u.pc  # Distancia en parsecs.
        }

    # Función que realiza una consulta a la base de datos Gaia para obtener estrellas cercanas a un exoplaneta.
    def query_nearby_stars(exoplanet, radius=1):
        # Se construyen las coordenadas del exoplaneta usando su RA, DEC y distancia.
        coord = SkyCoord(ra=exoplanet['ra'], dec=exoplanet['dec'], distance=exoplanet['distance'])
    
        # Consulta SQL para buscar las 1000 estrellas más cercanas dentro de un radio definido alrededor del exoplaneta.
        query = f"""
        SELECT TOP 1000 ra, dec, parallax, phot_g_mean_mag, bp_rp
        FROM gaiadr3.gaia_source
        WHERE 1=CONTAINS(
            POINT('ICRS', ra, dec),
            CIRCLE('ICRS', {coord.ra.deg}, {coord.dec.deg}, {radius})
        )
        AND parallax IS NOT NULL
        """
    
        # Lanzar la consulta de forma asíncrona a la base de datos de Gaia.
        job = Gaia.launch_job_async(query)
    
        # Obtener los resultados de la consulta.
        results = job.get_results()
        return results  # Devolver el conjunto de datos obtenidos.

    # Función que calcula la magnitud aparente de una estrella a partir de su magnitud absoluta y distancia.
    def calculate_apparent_magnitude(abs_mag, distance):
        return abs_mag + 5 * (np.log10(distance) - 1)  # Fórmula para convertir magnitud absoluta en magnitud aparente.

    # Función que determina el color de una estrella según su índice de color bp_rp (azul-rojo).
    def star_color_from_bp_rp(bp_rp):
        if bp_rp < 0.0:
            return "blue"  # Estrellas con bp_rp negativo son azules.
        elif bp_rp < 0.5:
            return "white"  # Estrellas con bp_rp entre 0.0 y 0.5 son blancas.
        elif bp_rp < 1.0:
            return "yellow"  # Estrellas con bp_rp entre 0.5 y 1.0 son amarillas.
        elif bp_rp < 1.5:
            return "orange"  # Estrellas con bp_rp entre 1.0 y 1.5 son naranjas.
        else:
            return "red"  # Estrellas con bp_rp mayor a 1.5 son rojas.

    # Función que simula una "vista del cielo" obteniendo y procesando datos de estrellas cercanas a un exoplaneta.
    def simulate_sky_view():
        # Obtener las coordenadas y distancia del exoplaneta.
        exoplanet = get_static_exoplanet_data()
        print(f"\nUsando coordenadas: RA = {exoplanet['ra']}, Dec = {exoplanet['dec']}, Distance = {exoplanet['distance']}")
    
        # Consultar las estrellas cercanas.
        stars = query_nearby_stars(exoplanet)
    
        # Si no se encuentran estrellas, se termina la función.
        if len(stars) == 0:
            print("No se encontraron estrellas en la región especificada.")
            return []

        # Imprimir información sobre los resultados obtenidos.
        print(f"Columnas disponibles en los resultados: {stars.colnames}")
        print(f"Número de estrellas encontradas: {len(stars)}")

        # Lista donde se almacenarán las estrellas procesadas para la vista del cielo.
        sky_view = []
    
        # Iterar sobre las estrellas obtenidas en la consulta.
        for star in stars:
            try:
                # Calcular la distancia de la estrella en parsecs a partir de la paralaje.
                distance = 1000 / star['parallax']  # La paralaje está en milisegundos de arco.
            
                # Calcular las diferencias de RA y Dec con respecto al exoplaneta.
                ra_diff = (star['ra'] - exoplanet['ra'].to(u.deg).value) * np.cos(np.radians(exoplanet['dec'].to(u.deg).value))
                dec_diff = star['dec'] - exoplanet['dec'].to(u.deg).value
            
                # Calcular las posiciones X, Y y Z relativas de la estrella respecto al exoplaneta.
                x = ra_diff * distance
                y = dec_diff * distance
                z = distance - exoplanet['distance'].value
            
                # Calcular la magnitud aparente de la estrella.
                apparent_mag = calculate_apparent_magnitude(star['phot_g_mean_mag'], distance)
            
                # Si la magnitud aparente no es un número válido (NaN), saltar esta estrella.
                if np.isnan(apparent_mag):
                    continue

                # Determinar el color de la estrella basado en su índice de color bp_rp.
                color = star_color_from_bp_rp(star['bp_rp'])
            
                # Agregar los datos de la estrella a la lista sky_view.
                sky_view.append({
                    'x': float(x),  # Convertir a float (el valor original puede ser de tipo np.float64).
                    'y': float(y),
                    'z': float(z),
                    'apparent_magnitude': apparent_mag,  # Magnitud aparente calculada.
                    'color': color  # Color determinado.
                })
            except KeyError as e:  # Si falta una columna en los datos de alguna estrella.
                print(f"Error al procesar una estrella: {e}")
                print(f"Columnas disponibles para esta estrella: {star.colnames}")
    
        return sky_view  # Devolver la lista de estrellas procesadas.

    # Función que guarda los datos en un archivo JSON.
    def save_to_json(data, filename):
        # Abrir el archivo en modo escritura ('w') y volcar los datos en formato JSON.
        with open(filename, 'w') as json_file:
            json.dump(data, json_file, indent=4)

    #Ejecutar la simulación de la vista del cielo.
    sky = simulate_sky_view()

    # Guardar el resultado de la simulación en un archivo JSON.
    save_to_json(sky, 'Estrellas_Exoplaneta.json')

    # Imprimir información sobre algunas estrellas como ejemplo.
    for star in sky:
        print(f"X: {star['x']}")
        print(f"Y: {star['y']}")
        print(f"Z: {star['z']}")
        print(f"Apparent_Magnitude: {star['apparent_magnitude']:.2f}")
        print(f"Color: {star['color']}")
        print()

else:
    print("\nPlaneta inexistente")
