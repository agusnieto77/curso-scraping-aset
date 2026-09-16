# Clase 2 — Scraping de páginas estáticas con rvest

**Duración:** 2 horas
**Objetivo:** pasar de *"extraje algo"* a *"extraje una tabla limpia y confiable"*.

> Requisito: haber corrido los scripts de la clase 1.

---

## De dónde venimos

La clase 1 terminó con una pregunta abierta: la portada tenía 89 títulos y solo 9 copetes.
¿Se pueden pegar los dos vectores en una tabla?

**No.** Y el problema no es que falle: el problema es que **no falla**. R arma la tabla sin
protestar, el copete de la nota 20 queda al lado del título de la nota 3, y vos publicás
un análisis sobre datos mal alineados sin haberte enterado nunca.

Esta clase resuelve eso. La regla es: **primero la unidad, después los campos.**

---

## Guion del encuentro

| Bloque | Min | Qué hacemos |
|---|---|---|
| **A** | 25 | Selectores CSS a fondo. Atributos vs. texto visible. XPath: sus dos casos de uso. → `01-selectores-css-y-xpath.R` |
| **B** | 25 | Del listado a la ficha: enlaces relativos y absolutos. Tablas HTML. → `02-tablas-y-atributos.R` |
| **C** | 25 | Caso real: portada de diario, extracción alineada por bloque. → `03-caso-prensa-limpieza.R` |
| **D** | 35 | Limpieza con stringr y búsqueda de patrones en el texto. |
| **E** | 10 | Exportar a CSV y JSON. Cierre y tarea. |

---

## Scripts

| Archivo | Qué enseña | Sitio |
|---|---|---|
| `01-selectores-css-y-xpath.R` | El mismo dato de tres formas. Datos que viven en atributos y en nombres de clase. | books.toscrape.com |
| `02-tablas-y-atributos.R` | Armar URLs desde un listado. `html_table()`. Migas de pan. | books.toscrape.com |
| `03-caso-prensa-limpieza.R` | Pipeline completo sobre un sitio real, con limpieza y exportación. | eldia.com |

Los dos primeros usan **books.toscrape.com**, un catálogo ficticio hecho para practicar.
Lo elegimos a propósito: no cambia nunca, así que si algo no funciona el problema es tu
código, no el sitio. Recién en el tercero vamos a un sitio real, que sí cambia.

---

## Las tres ideas de la clase

### 1. El texto visible no siempre es el dato

En books.toscrape.com el título aparece cortado en pantalla —`"A Light in the ..."`— pero
completo en el atributo `title`. La calificación en estrellas ni siquiera está escrita:
vive en el nombre de la clase, `class="star-rating Three"`.

Antes de extraer, mirá los atributos. Muchas veces el dato limpio ya está ahí.

### 2. Primero la unidad, después los campos

```r
# MAL: cada campo por su cuenta. Los largos no coinciden.
titulos <- portada |> html_elements(".nota__titulo-item")  |> html_text2()  # 89
copetes <- portada |> html_elements(".nota__introduccion") |> html_text2()  #  9

# BIEN: aislar el bloque, y buscar adentro de cada bloque.
notas_html <- portada |> html_elements("article.nota")                      # 89 bloques
titulos <- notas_html |> html_element(".nota__titulo-item")  |> html_text2() # 89
copetes <- notas_html |> html_element(".nota__introduccion") |> html_text2() # 89, con NA
```

La diferencia está en **`html_element()` en singular**. Aplicado sobre una lista de bloques,
devuelve exactamente un resultado por bloque, y `NA` donde el campo no existe.

Ese `NA` es un dato honesto: dice *"esta nota no tiene copete"*.

### 3. Un enlace relativo no es una URL

`href="/deportes/nota_123"` funciona en el navegador porque el navegador sabe de dónde lo
sacó. R no lo sabe. Hay que completarlo:

```r
paste0("https://www.eldia.com", enlace)
```

Si guardás rutas relativas en tu base de datos, en seis meses no vas a poder volver a la
fuente. Guardá siempre la URL completa.

---

## Ejercicios

**Sobre el script 1**
1. Extraé el precio de cada libro (`.price_color`).
2. Extraé la URL de la imagen de portada. Está en un atributo: ¿cuál?
3. Con XPath, traé solo los libros que estén `In stock`.

**Sobre el script 2**
4. Sacá el UPC y el precio sin impuestos de una ficha.
5. Escribí una función que reciba una URL y devuelva su tabla limpia.

**Sobre el script 3**
6. Cambiá `patron_laboral` por un tema de tu investigación.
7. Agregá una columna con `Sys.Date()`. ¿Por qué importa, si corrieras esto todos los días?

## Desafíos

**A.** Repetí el script 3 sobre `https://www.cba24n.com.ar`. Los selectores son otros:
buscalos vos. Después unificá ambas tablas con `bind_rows()` y una columna `medio`.
Eso ya es un corpus comparable de dos diarios.

**B.** Extraé el listado de tecnologías de
`https://vinculacion.conicet.gov.ar/tecnologias-y-capacidades-conicet/`.
Fijate primero si el contenido está en el HTML o lo carga JavaScript
(botón derecho → *Ver código fuente*). La respuesta define si podés resolverlo hoy
o si tenés que esperar a la clase 3.

---

## Tarea para la clase 3

Volvé al sitio que elegiste en la clase 1 y respondé:

1. ¿El listado está paginado? ¿Cómo cambia la URL al pasar de página?
2. ¿Cuántas páginas hay en total?
3. ¿El sitio tiene una API o un archivo de datos abiertos? Buscá en su pie de página,
   y probá `https://elsitio.com/robots.txt` a ver si menciona un `sitemap`.

La pregunta 3 es la importante. A veces te ahorra el scraping entero.

---

## Recursos

- [`recursos/chuleta-stringr.md`](recursos/chuleta-stringr.md) — limpieza y patrones de texto
- [`../clase-01-fundamentos/recursos/chuleta-selectores.md`](../clase-01-fundamentos/recursos/chuleta-selectores.md) — selectores CSS
- [`../docs/glosario.md`](../docs/glosario.md)
