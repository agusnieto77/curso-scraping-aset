# -----------------------------------------------------------------------------
# Clase 2 · Script 3 — Caso real: portada de diario, de punta a punta
#
# Qué hace:  extrae las notas de la portada de El Día como una tabla ORDENADA,
#            la limpia con stringr y la exporta en dos formatos.
# Necesita:  rvest, dplyr, stringr, readr, jsonlite. Internet (hay respaldo).
# Produce:   datos/salida/eldia-notas.csv
#            datos/salida/eldia-notas.json
# Duración:  segundos.
#
# Acá resolvemos el problema que quedó abierto en la clase 1:
# cómo extraer varios campos sin que se desalineen cuando alguno falta.
# -----------------------------------------------------------------------------

library(rvest)
library(dplyr)
library(stringr)
library(readr)
library(jsonlite)

usar_respaldo <- FALSE

origen <- if (usar_respaldo) {
  "clase-02-rvest-estaticas/datos/crudo/eldia-portada-respaldo.html"
} else {
  "https://www.eldia.com/"
}

portada <- read_html(origen)


# --- 1. Primero la unidad, después los campos --------------------------------
# En la clase 1 pedimos títulos por un lado y copetes por otro, y los largos
# no coincidían. La solución es invertir el orden: primero aislamos cada nota
# como un bloque, y recién adentro de cada bloque buscamos sus campos.

notas_html <- portada |> html_elements("article.nota")

length(notas_html)   # cada elemento es UNA nota completa


# --- 2. Extraer campo por campo, sobre la lista de bloques -------------------
# La clave está en html_element() en SINGULAR.
# Aplicado sobre una lista de 89 bloques, devuelve exactamente 89 resultados:
# uno por bloque. Si un bloque no tiene ese campo, devuelve NA en su posición.
#
# Con html_elements() (plural) devolvería solo los que existen, y volveríamos
# al problema de la clase 1.

notas <- tibble(
  titulo = notas_html |> html_element(".nota__titulo-item")   |> html_text2(),
  copete = notas_html |> html_element(".nota__introduccion")  |> html_text2(),
  enlace = notas_html |> html_element(".nota__titulo-item a") |> html_attr("href")
)

nrow(notas)
sum(is.na(notas$copete))   # muchos NA: la mayoría de las notas no tiene copete

# Y eso está BIEN. El NA es un dato: dice "esta nota no tiene copete".
# Antes teníamos copetes de otras notas ocupando ese lugar, sin aviso.


# --- 3. Limpieza con stringr -------------------------------------------------

notas <- notas |>
  mutate(
    # str_squish() saca espacios de más al principio, al final y en el medio.
    titulo = str_squish(titulo),
    copete = str_squish(copete),

    # El enlace es relativo: le falta el dominio.
    enlace = paste0("https://www.eldia.com", enlace),

    # La sección viene dentro de la propia URL: /politica-y-economia/nota...
    # str_extract() saca el primer trozo que coincida con el patrón.
    seccion = str_extract(enlace, "(?<=eldia[.]com/)[^/]+"),

    # El id de la nota son los dígitos del final.
    # Usamos [0-9] y no \d para no pelearnos con las barras invertidas:
    # en R, dentro de un texto entre comillas, una barra hay que escribirla dos veces.
    id = str_extract(enlace, "[0-9]+$"),

    # Largo del título, útil para detectar extracciones defectuosas.
    largo_titulo = str_length(titulo)
  ) |>
  filter(!is.na(titulo), titulo != "") |>
  distinct(id, .keep_all = TRUE)

notas |> count(seccion, sort = TRUE) |> head(8)


# --- 4. Buscar patrones en el texto ------------------------------------------
# Esto es lo que en la encuesta aparecía como "extracción selectiva por
# reconocimiento de patrones". Es str_detect() con una expresión regular.

# Buscamos notas sobre trabajo. La barra vertical significa "o".
patron_economia <- "inflac|empleo|salari|econom|precio|comerci"

economia <- notas |>
  filter(str_detect(str_to_lower(titulo), patron_economia))

nrow(economia)
economia |> select(seccion, titulo)

# str_to_lower() antes de buscar: si no, "Trabajo" con mayúscula no coincide.
# Es el error más común al escribir un filtro de texto.

# str_detect() dice SI hay coincidencia. str_extract() te trae QUÉ encontró.
# Acá sacamos la primera cifra que aparezca en cada título:
notas |>
  mutate(cifra = str_extract(titulo, "[0-9]+")) |>
  filter(!is.na(cifra)) |>
  select(cifra, titulo)

# Si buscaras porcentajes, el patrón sería "[0-9]+(?:[.,][0-9]+)?%"
# Leído en partes:  [0-9]+           uno o más dígitos
#                   (?:[.,][0-9]+)?  y opcionalmente coma o punto y más dígitos
#                   %                seguido del signo de porcentaje


# --- 5. Exportar -------------------------------------------------------------
# CSV para abrir en una planilla o volver a leer en R.

write_csv(notas, "clase-02-rvest-estaticas/datos/salida/eldia-notas.csv")

# JSON para cuando el dato tiene estructura anidada, o para pasarlo a otra
# herramienta. pretty = TRUE lo deja legible para una persona.

write_json(notas, "clase-02-rvest-estaticas/datos/salida/eldia-notas.json",
           pretty = TRUE, auto_unbox = TRUE)

cat("\n", nrow(notas), "notas guardadas en CSV y JSON.\n")


# -----------------------------------------------------------------------------
# EJERCICIO
#
# 1. Cambiá `patron_economia` por un tema de tu investigación y volvé a filtrar.
# 2. Agregá una columna con la fecha de descarga: Sys.Date().
#    ¿Por qué importa guardarla? (Pensá qué pasa si corrés esto todos los días
#     durante un mes.)
#
# DESAFÍO
#
# Repetí este script sobre https://www.cba24n.com.ar
# Los selectores son otros: inspeccioná la página y encontralos.
# Después unificá las dos tablas con bind_rows() y agregá una columna `medio`.
# Eso ya es un corpus comparable de dos diarios.
# -----------------------------------------------------------------------------
