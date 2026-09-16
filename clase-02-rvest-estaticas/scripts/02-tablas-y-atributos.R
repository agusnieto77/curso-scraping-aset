# -----------------------------------------------------------------------------
# Clase 2 · Script 2 — Tablas HTML y enlaces
#
# Qué hace:  arma la lista de URLs de un catálogo y extrae la ficha técnica
#            de un producto desde su tabla HTML.
# Necesita:  rvest, dplyr. Conexión a internet.
# Produce:   clase-02-rvest-estaticas/datos/salida/libros-urls.csv
# Duración:  segundos.
#
# Este script resuelve el problema más común del scraping a escala:
# el listado tiene poco, la ficha tiene todo. Necesitás las dos cosas.
# -----------------------------------------------------------------------------

library(rvest)
library(dplyr)
library(readr)

sitio <- "https://books.toscrape.com/"


# --- 1. Del listado a las URLs -----------------------------------------------

catalogo <- read_html(sitio)
libros   <- catalogo |> html_elements("article.product_pod")

fichas <- tibble(
  titulo = libros |> html_element("h3 a") |> html_attr("title"),
  ruta   = libros |> html_element("h3 a") |> html_attr("href")
)

fichas |> head(3)

# Mirá la columna `ruta`: dice "catalogue/a-light-in-the-attic_1000/index.html".
# Es una ruta RELATIVA: le falta el dominio adelante.
# Un enlace relativo funciona en el navegador porque el navegador sabe de dónde
# lo sacó. R no lo sabe: hay que completarlo a mano.

fichas <- fichas |>
  mutate(url = paste0(sitio, ruta))

fichas |> select(titulo, url) |> head(3)

write_csv(fichas, "clase-02-rvest-estaticas/datos/salida/libros-urls.csv")


# --- 2. Entrar a una ficha ---------------------------------------------------
# Con la URL armada, entramos a la primera. Una sola, por ahora:
# recorrer las 1000 del sitio es el tema de la clase 3.

ficha <- read_html(fichas$url[1])

ficha |> html_element("h1") |> html_text2()


# --- 3. La tabla ---------------------------------------------------------------
# Si el dato ya viene en una <table>, no hace falta extraer campo por campo.
# html_table() la convierte en data frame de una.

tabla <- ficha |> html_element("table.table-striped") |> html_table()
tabla

# Fijate en la forma: dos columnas, sin encabezado. Los nombres de los campos
# están en la primera columna, no arriba. Es una tabla "vertical".
#
# rvest la lee bien, pero le pone nombres genéricos (X1, X2) porque el HTML
# no le dio otros. Le ponemos nombres nosotros:

tabla <- tabla |> setNames(c("campo", "valor"))
tabla


# --- 4. Cuando querés UN dato suelto -----------------------------------------
# Si solo te interesa la disponibilidad, filtrás el data frame:

tabla |> filter(campo == "Availability") |> pull(valor)

# O lo pedís directo con XPath, buscando el <th> por su texto y saltando
# a la celda hermana. Esto es exactamente lo que CSS no puede hacer:

ficha |>
  html_element(xpath = "//th[text()='Availability']/following-sibling::td") |>
  html_text2()

# Las dos formas dan lo mismo. La primera es más legible; la segunda evita
# traerte la tabla entera cuando solo querés un campo.


# --- 5. Atributos que no se ven ----------------------------------------------
# La categoría del libro no está escrita como tal en ningún lado.
# Está en las migas de pan (breadcrumb), en la anteúltima posición.

ficha |> html_elements("ul.breadcrumb li a") |> html_text2()

# La imagen de portada tampoco está en el texto: está en el src de un <img>.
ficha |> html_element("#product_gallery img") |> html_attr("src")


# -----------------------------------------------------------------------------
# EJERCICIO
#
# 1. Extraé el UPC (Universal Product Code) y el precio sin impuestos de la 
#    ficha, usando el data frame.
# 2. Armá una función de una línea que reciba una URL y devuelva su tabla limpia.
#    (No la corras sobre las 1000 fichas todavía: eso necesita las pausas
#     y el manejo de errores que vemos en la clase 3.)
# -----------------------------------------------------------------------------
