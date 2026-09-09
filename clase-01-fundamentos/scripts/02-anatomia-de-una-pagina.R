# -----------------------------------------------------------------------------
# Clase 1 · Script 2 — Anatomía de una página web
#
# Qué hace:  abre una página HTML mínima guardada en tu computadora y muestra
#            cómo pedirle pedazos concretos.
# Necesita:  el paquete rvest. NO necesita internet.
# Produce:   salida en consola.
# Duración:  instantáneo.
#
# Por qué una página local: las páginas reales tienen miles de líneas de ruido
# (publicidad, scripts, estilos). Acá el HTML entra en una pantalla y podés
# abrirlo en paralelo con un editor de texto para ir comparando.
# -----------------------------------------------------------------------------

library(rvest)

# --- 1. Leer la página -------------------------------------------------------
# read_html() convierte el archivo de texto en un ÁRBOL: una estructura donde
# cada etiqueta HTML es una rama que cuelga de otra. Ese árbol es el DOM.

pagina <- read_html("clase-01-fundamentos/recursos/pagina-ejemplo.html")

pagina
# Fijate que imprime <html>, y adentro <head> y <body>. Eso es el árbol.


# --- 2. Pedir UN elemento ----------------------------------------------------
# html_element() (singular) devuelve el PRIMERO que encuentra.
# El texto entre comillas es un SELECTOR CSS: la dirección del elemento.

pagina |> html_element("h1")
# El h1 completo, con su etiqueta.

pagina |> html_element("h1") |> html_text2()
# Solo el texto. html_text2() además limpia espacios y saltos de línea sobrantes.


# --- 3. Pedir VARIOS elementos -----------------------------------------------
# html_elements() (plural) devuelve TODOS los que coinciden.

titulos <- pagina |> html_elements(".nota-titulo") |> html_text2()
titulos
length(titulos)   # tres notas, tres títulos


# --- 4. Cómo se escribe un selector ------------------------------------------
# Estas son las tres formas que vas a usar el 90% del tiempo:

pagina |> html_elements("article")   |> length()  # por etiqueta
pagina |> html_elements(".nota")     |> length()  # por clase      -> punto
pagina |> html_elements("#resumen")  |> length()  # por id         -> numeral

# Y se combinan. Este pide: los elementos con clase "nota-titulo"
# que estén DENTRO de un article con clase "destacada".
pagina |> html_elements("article.destacada .nota-titulo") |> html_text2()


# --- 5. El texto no es lo único ----------------------------------------------
# Los enlaces guardan su destino en el atributo href, no en el texto visible.
# html_attr() saca atributos.

pagina |> html_elements(".nota-titulo a") |> html_attr("href")


# --- 6. Las tablas tienen atajo ----------------------------------------------
# Si el dato ya viene en una <table>, rvest la convierte en data frame solo.

pagina |> html_element("#resumen") |> html_table()


# --- 7. La trampa que vas a encontrar siempre --------------------------------
# La tercera nota NO tiene copete. Mirá qué pasa:

pagina |> html_elements(".nota-copete") |> html_text2()   # devuelve 2
pagina |> html_elements(".nota-titulo") |> html_text2()   # devuelve 3

# Si armaras una tabla pegando estos dos vectores, el copete de la nota 3
# terminaría al lado del título de la nota 2. Los datos quedarían MAL,
# y no habría ningún error que te avise.
#
# La solución es no extraer campo por campo, sino recorrer nota por nota.
# Eso lo vemos en la clase 2. Por ahora quedate con el problema:
# alinear vectores de distinto largo es la causa de error más común del scraping.
