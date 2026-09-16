# -----------------------------------------------------------------------------
# Clase 2 · Script 1 — Selectores: CSS, XPath y el dato escondido
#
# Qué hace:  extrae el mismo dato de tres formas distintas y muestra por qué
#            una es más sólida que las otras.
# Necesita:  rvest. Conexión a internet.
# Produce:   salida en consola.
# Duración:  segundos.
#
# Sitio:     books.toscrape.com — un catálogo ficticio hecho para practicar.
#            Trabajamos acá primero porque no cambia nunca: lo que ves hoy
#            va a estar igual la semana que viene. Después vamos a un sitio real.
# -----------------------------------------------------------------------------

library(rvest)

catalogo <- read_html("https://books.toscrape.com/")


# --- 1. El bloque que se repite ----------------------------------------------
# Antes de extraer nada: identificá cuál es la unidad que se repite.
# Acá cada libro está envuelto en un <article class="product_pod">.

libros <- catalogo |> html_elements("article.product_pod")
length(libros)   # 20 libros por página


# --- 2. El texto visible miente ----------------------------------------------
# El título está en un <h3> con un <a> adentro. Sacamos su texto:

libros |> html_element("h3 a") |> html_text2() |> head(3)

# Mirá el resultado: "A Light in the ...". Está CORTADO.
# El sitio recorta el título para que entre en el diseño.
#
# Pero el título completo está guardado en el atributo `title`:

libros |> html_element("h3 a") |> html_attr("title") |> head(3)

# Primera lección de la clase: el dato que ves en la pantalla no siempre es
# el dato que el HTML tiene. Antes de extraer, mirá los atributos.


# --- 3. Datos que no están en el texto ---------------------------------------
# La calificación en estrellas no está escrita en ningún lado del texto.
# Está en el NOMBRE DE LA CLASE: <p class="star-rating Three">

libros |> html_element("p.star-rating") |> html_attr("class") |> head(5)

# Devuelve "star-rating Three". La calificación es la segunda palabra.
# En el script 3 vemos cómo separarla con stringr.


# --- 4. Tres formas de pedir lo mismo ----------------------------------------
# Estas tres líneas devuelven exactamente el mismo resultado.

# (a) Por clase con nombre propio — la más robusta.
catalogo |> html_elements("article.product_pod h3 a") |> html_attr("title") |> head(2)

# (b) Por etiqueta sola — funciona hoy, pero si el sitio agrega un <h3>
#     en el pie de página, se te cuela basura.
catalogo |> html_elements("h3 a") |> html_attr("title") |> head(2)

# (c) Por posición — esto es lo que te copia el navegador con "Copy selector".
#     Describe un lugar exacto en el árbol. Se rompe con cualquier rediseño.
catalogo |> html_elements("ol.row > li:nth-child(1) h3 a") |> html_attr("title")

# Usá siempre (a) cuando exista una clase con nombre propio.
# `product_pod` no es un accidente: alguien la eligió para significar "un libro".
# Por eso dura.


# --- 5. Cuándo CSS no alcanza: XPath -----------------------------------------
# CSS no puede seleccionar un elemento por lo que CONTIENE adentro.
# Pregunta: ¿qué libros tienen 5 estrellas?

cinco_estrellas <- catalogo |>
  html_elements(xpath = "//article[.//p[contains(@class, 'Five')]]")

length(cinco_estrellas)
cinco_estrellas |> html_element("h3 a") |> html_attr("title")

# Se lee así:
#   //article                        cualquier <article>, a cualquier profundidad
#   [ ... ]                          que cumpla esta condición
#   .//p                             que adentro suyo tenga un <p>
#   [contains(@class, 'Five')]       cuya clase contenga "Five"

# XPath también sabe subir al elemento padre, algo que CSS no puede:
catalogo |>
  html_elements(xpath = "//p[@class='price_color']/parent::div") |>
  length()

# Regla práctica: empezá con CSS. Pasate a XPath solo cuando choques
# contra uno de estos dos límites (buscar por contenido, o subir al padre).


# -----------------------------------------------------------------------------
# EJERCICIO
#
# 1. Extraé el precio de cada libro (clase .price_color).
# 2. Extraé la URL de la imagen de portada de cada libro.
#    Pista: está en un atributo, no en el texto. ¿Cuál?
# 3. Con XPath, traé solo los libros que estén "In stock".
# -----------------------------------------------------------------------------
