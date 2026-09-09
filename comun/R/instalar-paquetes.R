# -----------------------------------------------------------------------------
# Instalación de paquetes del curso
#
# Qué hace:  instala los paquetes que usamos en los cuatro encuentros.
# Necesita:  conexión a internet. Nada más.
# Produce:   nada en disco. Deja los paquetes instalados en tu sistema.
# Cuándo:    una sola vez, antes del primer encuentro.
# -----------------------------------------------------------------------------

# Los paquetes que vamos a usar, agrupados por para qué sirven.
paquetes <- c(
  # --- Extracción ---
  "rvest",     # leer páginas HTML y sacarles el contenido
  "httr2",     # hacer pedidos HTTP con control fino (APIs, formularios)

  # --- Manipulación de datos ---
  "dplyr",     # filtrar, ordenar, transformar tablas
  "stringr",   # trabajar con texto (limpiar, buscar patrones)
  "purrr",     # repetir una operación sobre muchos elementos
  "readr",     # leer y escribir CSV

  # --- Formatos y almacenamiento ---
  "jsonlite",  # leer y escribir JSON
  "DBI",       # conectarse a bases de datos
  "RSQLite"    # base de datos SQLite, liviana y sin servidor
)

# Instalamos solo los que faltan: si ya los tenés, no perdemos tiempo.
faltantes <- paquetes[!paquetes %in% rownames(installed.packages())]

if (length(faltantes) > 0) {
  message("Instalando ", length(faltantes), " paquete(s): ",
          paste(faltantes, collapse = ", "))
  install.packages(faltantes)
} else {
  message("Todos los paquetes ya estaban instalados.")
}

# chromote va aparte porque necesita un navegador Chrome/Chromium en tu equipo
# y en algunas computadoras da problemas. Lo usamos solo en una demostración
# de la clase 3, así que si falla podés seguir el curso sin él.
if (!requireNamespace("chromote", quietly = TRUE)) {
  message("\nInstalando chromote (opcional, para la clase 3)...")
  try(install.packages("chromote"))
}

message("\nListo. Ahora corré 01-verificar-entorno.R")
