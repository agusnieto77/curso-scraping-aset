# -----------------------------------------------------------------------------
# Clase 1 · Script 0 — DEMO DE APERTURA
#
# Qué hace:  recorre un caso completo de punta a punta, en vivo, para mostrar
#            adónde vamos a llegar. Nadie tiene que entender el código todavía.
# Necesita:  rvest, tidyverse, tidytext, stopwords, ggwordcloud, chromote.
#            Conexión a internet.
# Produce:   una nube de palabras con el vocabulario de los avisos de empleo.
# Duración:  entre 1 y 2 minutos de ejecución. Reservar 30 minutos de clase.
#
# CÓMO SE USA
# Se corre línea por línea con Ctrl + Enter, mostrando cada resultado.
# El objetivo NO es que sigan el código: es que vean el recorrido entero y
# entiendan que cada paso es simple. Las explicaciones vienen después.
#
# Al terminar, la frase que cierra el bloque es:
#   "Todo esto lo van a poder escribir ustedes en cuatro clases."
# -----------------------------------------------------------------------------

library(tidyverse)      # dplyr, ggplot2, stringr y compañía
library(tidytext)       # separar texto en palabras
library(stopwords)      # listas de palabras vacías ("de", "que", "para")
library(ggwordcloud)    # nube de palabras
library(rvest)          # scraping


# =============================================================================
# PARTE 1 — Lo que ve tu navegador NO es lo que ve R
# =============================================================================
# Esta es LA idea de la clase 1. Todo lo demás se desprende de acá.

url <- 'https://ar.computrabajo.com/trabajo-de-vendedor?p=211'
url

# Abrí esa dirección en el navegador, al lado. Se ve una lista de avisos.
# Ahora pidámosle a R exactamente la misma dirección:

# Lo envolvemos en try() para que el error se IMPRIMA pero no corte el script:
# ese mensaje de error es justamente lo que queremos mostrar.
try(pagina <- read_html(url))

# ERROR: "no se puede abrir la conexión".
#
# No es un problema de tu internet ni de tu código. El servidor respondió
# 403 (Prohibido). Reconoció que del otro lado no había una persona con un
# navegador, sino un programa, y decidió no atender.
#
# Ese sitio ni siquiera deja leer su propio robots.txt. Es una decisión
# deliberada y está en su derecho.
#
# >>> MOMENTO CLAVE DE LA CLASE <<<
# Un bloqueo no es un obstáculo técnico a esquivar: es un mensaje.
# En la clase 4 volvemos sobre este caso exacto, con el checklist ético
# en la mano, para decidir qué corresponde hacer cuando un sitio dice que no.
# Hoy lo usamos para mostrar la diferencia entre las dos formas de pedir.


# --- La otra forma de pedir --------------------------------------------------
# read_html_live() no descarga el HTML: abre un NAVEGADOR DE VERDAD
# (Chrome, sin ventana visible), lo deja cargar la página como si fueras vos,
# y recién ahí lee el resultado.

pagina <- read_html_live(url)
pagina

# Ahora sí. Misma dirección, dos herramientas, dos resultados.
#
# La diferencia importa por dos motivos distintos, y conviene no mezclarlos:
#
#   1. TÉCNICO: muchos sitios arman su contenido con JavaScript. El HTML
#      que llega es casi vacío y lo llena el navegador. read_html() ve el
#      sobre; read_html_live() ve la carta abierta.
#
#   2. DE ACCESO: un navegador real también pasa filtros que rechazan
#      programas. Eso NO convierte al dato en público ni el uso en legítimo:
#      solo cambia cómo golpeás la puerta.
#
# El primer motivo es el tema de la clase 3. El segundo, el de la clase 4.
# Hoy alcanza con que vean que existen dos caminos y que no son lo mismo.


# =============================================================================
# PARTE 2 — Apuntarle a un pedazo de la página
# =============================================================================
# Una página web es un árbol de etiquetas. Para sacarle algo hay que decirle
# a R QUÉ rama querés. Eso se hace con un "selector".
#
# El selector se encuentra en el navegador:
#   botón derecho sobre un aviso -> Inspeccionar
#
# Ahí se ve que cada aviso está envuelto en:  <article class="box_offer">

tag_html <- "article"          # el tipo de etiqueta
tag_html

clase_css <- ".box_offer"      # la clase. El punto adelante significa "clase"
clase_css

html_css <- paste0(tag_html, clase_css)   # los pegamos: "article.box_offer"
html_css

# Se lee: "los <article> que tengan la clase box_offer".
# Separarlo en dos variables es a propósito, para que se vea que un selector
# no es una fórmula mágica: son dos pedazos que uno junta.


# --- Los avisos --------------------------------------------------------------

pagina <- read_html_live(url)
pagina

nodos <- html_elements(pagina, html_css)
nodos

length(nodos)   # 20 avisos en esta página

# Cada elemento de `nodos` es UN aviso completo, con todo adentro.
# Ahora buscamos cosas dentro de cada uno.


# =============================================================================
# PARTE 3 — Sacar el texto y los enlaces
# =============================================================================

# --- Los títulos: están en un <h2> ---
titulos_nodos <- html_elements(nodos, "h2")
titulos_nodos

titulos_txt <- html_text2(titulos_nodos)
titulos_txt

# Fijate que a algunos títulos les cuelga un "Postulado" o un "Vista".
# Son etiquetas de estado que el sitio dibuja adentro del mismo <h2>.
# Limpiarlas es trabajo de la clase 2. Que lo VEAN sucio ahora es bueno:
# el dato real nunca viene limpio.


# --- Los enlaces: el destino está en el atributo href, no en el texto ---
links_nodos <- html_elements(nodos, "a.js-o-link")
links_nodos

links_txt <- html_attr(links_nodos, 'href')
links_txt

# Salen así: "/ofertas-de-trabajo/oferta-de-trabajo-de-..."
# Les falta el dominio adelante: son direcciones RELATIVAS.
# El navegador sabe completarlas porque sabe de dónde las sacó. R no.

links_completos <- url_absolute(links_txt, url)
links_completos

# url_absolute() hace exactamente eso: le pega el dominio.


# =============================================================================
# PARTE 4 — Entrar a cada aviso
# =============================================================================
# Hasta acá tenemos el LISTADO. Pero el texto de la búsqueda laboral está
# adentro de cada ficha. Hay que entrar a cada una.
#
# Este es el salto conceptual más grande del curso: de una página a muchas.
# Es el tema de la clase 3.

# En la demo entramos solo a unas pocas. Cada ficha tarda unos 5 segundos
# porque hay que abrir un navegador entero para cada una: con las 20 serían
# casi dos minutos de espera con la clase mirando.
n_fichas <- 5

contenido <- c()

for (l in links_completos[1:n_fichas]) {

  ficha <- read_html_live(l)

  # p.mbB es el párrafo con la descripción del puesto.
  # html_element() en singular trae el primero, que es el que nos interesa.
  body <- html_text2(html_element(ficha, 'p.mbB'))

  contenido <- append(contenido, body)

  # Cerrar el navegador. Si no lo hacés, cada vuelta deja un Chrome abierto
  # comiendo memoria, y a la décima ficha la máquina se arrastra.
  ficha$session$close()

  cat('\n\n', 'link: ', l, '\n\n', body)

  Sys.sleep(1)   # una pausa entre pedido y pedido. Cortesía básica.
}

length(contenido)


# =============================================================================
# PARTE 5 — De texto a datos
# =============================================================================
# Ya tenemos los textos. Esto ya no es scraping: es análisis.
# Se muestra rápido, solo para cerrar el círculo y que vean para qué sirve
# todo lo anterior.

# Palabras que no aportan nada a este corpus en particular.
# La lista crece a medida que uno mira los resultados.
palabras_extra <- c("días", "etc")

palabras <- tibble(contenido) |>

  # --- Sacar avisos repetidos ---
  # Las plataformas de empleo republican el mismo aviso varias veces: la misma
  # empresa, el mismo texto, distinta URL. Si no los quitamos, ese aviso cuenta
  # dos o tres veces y su vocabulario se infla.
  #
  # count() agrupa por el texto completo de cada ficha, así que las repetidas
  # colapsan en una sola fila. select() se queda con el texto y descarta la
  # cuenta, que ya cumplió su función.
  count(texto = contenido, name = 'freq') |>
  select(texto) |>

  # --- De texto a palabras ---
  unnest_tokens(palabra, texto) |>                       # una fila por palabra
  filter(
    !palabra %in% c(stopwords("es"), palabras_extra),    # sacar palabras vacías
    nchar(palabra) > 2                                   # sacar las muy cortas
  ) |>
  count(palabra, sort = TRUE) |>                         # contar
  slice_max(n, n = 50)                                   # quedarse con el top 50

# NOTA: distinct(texto) hace exactamente lo mismo que ese count() + select(),
# en un solo paso. Es la función que vamos a usar en el resto del curso para
# quitar duplicados. Las dos formas son correctas.

palabras

# OJO CON EL RESULTADO, y decilo en voz alta:
# con solo 5 fichas, la nube queda dominada por el vocabulario de una o dos
# empresas. "cloud", "aws", "devops" no describen al mercado de vendedores:
# describen a los avisos que nos tocaron.
#
# Sacar los repetidos ayuda, pero no arregla esto: son dos problemas distintos.
#   - Avisos duplicados     -> se resuelve con código (lo hicimos recién).
#   - Muestra chica y sesgada -> se resuelve con diseño: más fichas, más
#     páginas, un criterio de selección que puedas justificar.
#
# El primero es técnico. El segundo es metodológico, y es el que importa.
# Ese es el argumento entero del curso: no se trata de raspar, se trata de
# construir un corpus del que puedas dar cuenta.

palabras |>
  ggplot(aes(label = palabra, size = n, color = palabra)) +
  geom_text_wordcloud_area() +
  scale_size_area(max_size = 22) +
  theme_void()


# =============================================================================
# EL CIERRE DE LA DEMO
# =============================================================================
#
# Repasar en voz alta lo que acaba de pasar, sin código:
#
#   1. Le pedimos una página a un sitio.       -> nos dijo que no
#   2. Se la pedimos de otra forma.            -> entramos
#   3. Le apuntamos a los avisos.              -> 20 bloques
#   4. Sacamos títulos y enlaces.              -> texto y atributos
#   5. Entramos a cada ficha.                  -> iteración
#   6. Contamos palabras y dibujamos.          -> datos
#
# Seis pasos. Ninguno complicado por separado.
#
# Y una pregunta para dejar picando, que es la que abre la clase 4:
#
#   El paso 1 falló porque el sitio no quiso atendernos.
#   El paso 2 funcionó porque golpeamos distinto.
#   ¿Alcanza con que funcione?
#
# No la contesten hoy. Vuelvan a ella en la última clase.
#
#
# NOTA PARA EL DOCENTE
# -----------------------------------------------------------------------------
# Los sitios cambian. Antes de cada dictado, verificar en 30 segundos:
#
#   pagina <- read_html_live(url)
#   length(html_elements(pagina, "article.box_offer"))   # tiene que dar 20
#
# Si da 0, el selector cambió: inspeccionar de nuevo y actualizar `clase_css`.
#
# Alternativa si el sitio no responde el día de la clase: el mismo recorrido
# funciona sobre eldia.com con read_html() y el selector ".nota__titulo-item",
# que es el caso del script 03 de esta clase. Se pierde el contraste del
# paso 1, que es lo más valioso de la demo, pero se salva el recorrido.
# -----------------------------------------------------------------------------
