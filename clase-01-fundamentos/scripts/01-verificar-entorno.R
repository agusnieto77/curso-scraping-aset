# -----------------------------------------------------------------------------
# Clase 1 · Script 1 — Verificar que el entorno funciona
#
# Qué hace:  revisa la versión de R, los paquetes y la conexión al sitio
#            que vamos a usar en clase.
# Necesita:  haber corrido antes comun/R/instalar-paquetes.R
# Produce:   mensajes en la consola. No escribe archivos.
# Duración:  menos de un minuto.
#
# IMPORTANTE: abrí siempre curso-scraping-aset.Rproj antes de correr esto.
# -----------------------------------------------------------------------------

# --- 1. Versión de R ---------------------------------------------------------
# Necesitamos R 4.3 o superior. Versiones más viejas no soportan httr2.

cat("R instalado:", R.version.string, "\n")

version_ok <- getRversion() >= "4.3.0"
if (!version_ok) {
  cat("  [!] Tu versión de R es vieja. Actualizá desde https://cran.r-project.org\n")
}

# --- 2. Paquetes -------------------------------------------------------------
# requireNamespace() pregunta "¿está este paquete?" sin cargarlo.
# Es la forma limpia de verificar sin llenar la sesión de cosas.

paquetes <- c("rvest", "httr2", "dplyr", "stringr", "purrr", "readr", "jsonlite")

cat("\nPaquetes:\n")
for (p in paquetes) {
  presente <- requireNamespace(p, quietly = TRUE)
  cat("  ", if (presente) "[ok]" else "[FALTA]", p, "\n")
}

faltantes <- paquetes[!sapply(paquetes, requireNamespace, quietly = TRUE)]

# --- 3. Conexión al sitio de práctica ----------------------------------------
# Probamos contra el diario que vamos a usar en clase.
# Si esto falla no es grave: los scripts tienen una copia local de respaldo.

cat("\nConexión a eldia.com: ")
hay_internet <- tryCatch({
  con <- url("https://www.eldia.com/", open = "rb")
  close(con)
  TRUE
}, error = function(e) FALSE)

cat(if (hay_internet) "[ok]\n" else "[sin conexión — usaremos el respaldo local]\n")

# --- 4. Resultado ------------------------------------------------------------

cat("\n")
if (version_ok && length(faltantes) == 0) {
  cat("Entorno listo. Nos vemos en clase.\n")
} else {
  cat("Falta resolver algo antes del encuentro:\n")
  if (!version_ok)             cat("  - Actualizar R a 4.3 o superior.\n")
  if (length(faltantes) > 0)   cat("  - Instalar:", paste(faltantes, collapse = ", "),
                                   "\n    Corré: source('comun/R/instalar-paquetes.R')\n")
  cat("\nEscribilo en el canal de consultas y lo vemos.\n")
}
