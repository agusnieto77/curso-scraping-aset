# -----------------------------------------------------------------------------
# Clase 1 · Script 3 — Tu primer scraping real
#
# Qué hace:  descarga la portada del diario El Día (La Plata) y extrae los
#            títulos de las notas con sus enlaces.
# Necesita:  rvest, dplyr, readr. Conexión a internet (hay respaldo local).
# Produce:   clase-01-fundamentos/datos/salida/eldia-titulos.csv
# Duración:  unos segundos.
#
# Por qué este sitio: es un diario argentino, público, y arma su HTML en el
# servidor. Eso significa que lo que ves en el navegador es lo que llega a R.
# No todos los sitios son así, y en la clase 3 vemos qué hacer con los otros.
# -----------------------------------------------------------------------------

library(rvest)
library(dplyr)
library(readr)

# Poné TRUE si no tenés internet, o si el sitio no responde durante la clase.
usar_respaldo <- FALSE


# --- 1. Traer la página ------------------------------------------------------

if (usar_respaldo) {
  origen <- "clase-01-fundamentos/datos/crudo/eldia-portada-respaldo.html"
} else {
  origen <- "https://www.eldia.com/"
}

portada <- read_html(origen)


# --- 2. Encontrar el selector ------------------------------------------------
# ¿De dónde salió ".nota__titulo-item"? Del navegador: botón derecho sobre un
# título -> Inspeccionar. Ahí se ve la etiqueta y sus clases.
#
# Hacelo vos ahora mismo con eldia.com abierto al lado. No sigas hasta verlo.

titulos <- portada |> html_elements(".nota__titulo-item")

length(titulos)   # cuántas notas encontramos


# --- 3. Sacar el texto y el enlace -------------------------------------------
# Cada título es un <h2> que adentro tiene un <a>. El texto está en el <a>
# y el destino, en su atributo href.

enlaces <- titulos |> html_element("a")   # singular: el primer <a> de cada título

texto <- enlaces |> html_text2()
href  <- enlaces |> html_attr("href")

# Usamos html_element() (singular) sobre la lista de títulos a propósito:
# devuelve exactamente un resultado por título, y si alguno no tuviera <a>
# devuelve NA en vez de correr todo el vector. Los largos quedan alineados.


# --- 4. Armar la tabla -------------------------------------------------------

notas <- tibble(
  titulo = texto,
  enlace = href
)

# Los href vienen relativos ("/politica/..."). Para que sirvan hay que
# completarlos con el dominio.
notas <- notas |>
  mutate(enlace = paste0("https://www.eldia.com", enlace)) |>
  filter(!is.na(titulo), titulo != "") |>
  distinct(titulo, .keep_all = TRUE)   # el mismo título puede repetirse en la portada

notas


# --- 5. Guardar --------------------------------------------------------------
# Siempre guardamos lo que recolectamos. Un scraping que no deja archivo
# es un scraping que vas a tener que volver a correr.

write_csv(notas, "clase-01-fundamentos/datos/salida/eldia-titulos.csv")

cat("\nListo:", nrow(notas), "notas guardadas en datos/salida/eldia-titulos.csv\n")


# -----------------------------------------------------------------------------
# EJERCICIO
#
# La portada también tiene copetes, con la clase .nota__introduccion
# Extraelos y fijate cuántos hay.
#
# Vas a encontrar muchos menos copetes que títulos. ¿Por qué?
# ¿Podrías pegarlos a esta tabla tal como están? (Repasá el punto 7
# del script anterior antes de contestar.)
# -----------------------------------------------------------------------------
