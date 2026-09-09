# Preguntas frecuentes

Se va completando con las consultas del curso. Si tu pregunta no está, mandala al canal.

---

## Entorno

### "No encuentro el archivo" / "cannot open file"

Casi siempre es lo mismo: **no abriste el proyecto**. Cerrá RStudio, abrí
`curso-scraping-aset.Rproj` con doble clic, y volvé a correr el script.

Para verificar dónde está parado R:

```r
getwd()
```

Tiene que terminar en `curso-scraping-aset`. Si termina en otra cosa, ese es el problema.

### "The following object is masked from..."

No es un error. Es un aviso: dos paquetes tienen una función con el mismo nombre y R te
avisa cuál va a usar (la del último que cargaste). Podés ignorarlo.

### Los acentos se ven mal: `Ã³`, `Ã±`, `â€œ`

Dos causas posibles.

**En el editor:** `Tools → Global Options → Code → Saving → Default text encoding: UTF-8`.
Después reabrí el archivo.

**En una página descargada:** el sitio usa una codificación vieja. Decíselo a rvest:

```r
resp |> resp_body_html(encoding = "ISO-8859-1")
```

Muchos sistemas públicos argentinos son anteriores a UTF-8. El buscador de convenios
de la clase 3 es uno.

---

## Selectores

### Mi script devuelve 0 filas y no da error

El caso más común de todos, y el más peligroso: **no hay error porque no hay nada roto**.
El selector simplemente no coincide.

1. Abrí la página en el navegador.
2. Botón derecho sobre el dato → **Inspeccionar**.
3. Mirá la etiqueta y sus clases.
4. Probá el selector solo, sin el resto del pipeline:

```r
pagina |> html_elements("tu-selector") |> length()
```

Si eso da 0, el problema es el selector. Si da un número, el problema está más abajo.

### Copié el selector del navegador y no funciona

El navegador te da algo como
`#root > div:nth-child(3) > div > article:nth-child(1) > h2`.

Eso describe una **posición exacta** en el árbol. Funciona hoy y se rompe con cualquier
rediseño, o si la página carga un banner de más.

Buscá siempre una clase con nombre propio: `.nota__titulo-item`. Esa clase existe porque
alguien la eligió para significar algo, y por eso dura.

### Los datos me quedan desalineados

Extrajiste campo por campo y alguno faltaba en algunos bloques. Es el problema de la clase 2.

**Solución:** primero aislá la unidad, después buscá los campos adentro.

```r
bloques <- pagina |> html_elements("article.nota")   # la unidad

tibble(
  titulo = bloques |> html_element(".titulo") |> html_text2(),
  copete = bloques |> html_element(".copete") |> html_text2()   # NA donde falte
)
```

`html_element()` en **singular** sobre una lista de bloques devuelve un resultado por
bloque, con `NA` donde el campo no existe. `html_elements()` en plural devuelve solo los
que existen, y ahí se desalinea todo.

### El dato lo veo en el navegador pero no en R

Lo está armando JavaScript. Para confirmarlo: botón derecho → **Ver código fuente de la
página** (no "Inspeccionar"). El código fuente es lo que recibe R; el inspector muestra
la página ya armada.

Tres salidas, de mejor a peor:

1. Buscá si hay una **API** (pestaña Network del navegador, filtro XHR).
2. Buscá el **JSON dentro del propio HTML**, en alguna etiqueta `<script>`. Pasa mucho más
   seguido de lo que parece. Ver clase 3, script 4.
3. Renderizá con **chromote**. Lento, frágil y pesado: último recurso.

---

## Errores y bloqueos

### Me devuelve 403

El sitio no atiende programas automáticos. Antes de asumir que es un problema técnico,
probá su `robots.txt`: si eso también da 403, la decisión es deliberada.

Qué hacer: buscar API, sitemap, portal de datos abiertos, u otra fuente con el mismo dato.
Ver el checklist de la clase 4.

### Me devuelve 429

Estás pidiendo demasiado rápido. Subí la pausa y agregá un tope:

```r
req_throttle(rate = 20 / 60)   # máximo 20 pedidos por minuto
```

Un 429 es el sitio pidiéndote que bajes el ritmo. Es la advertencia antes del 403.

### Aparece un CAPTCHA

El sitio decidió que quiere personas, no programas. Este curso no enseña a resolverlos,
y no por timidez: en ese punto el problema deja de ser técnico y el margen legal se angosta.

Las alternativas están en el checklist ético: otra fuente, pedido formal de acceso,
solicitud de información pública, o reformular la pregunta.

### El script anda un rato y después se cae

Envolvé la función con `possibly()` para que un error no tire abajo toda la corrida:

```r
bajar_seguro <- possibly(bajar_pagina, otherwise = tibble())
resultado <- map(1:50, bajar_seguro) |> list_rbind()
```

Perdés una página, no cincuenta.

---

## Escala y almacenamiento

### ¿Cuánto va a tardar bajar todo?

Hacé la cuenta antes de apretar Enter:

```
páginas × segundos de pausa = tiempo mínimo
33 × 2  = poco más de un minuto
1000 × 2 = unos 33 minutos
```

Si el número te asusta, achicá la búsqueda. Casi nunca necesitás todo.

### ¿Cuándo paso de CSV a base de datos?

Cuando pase alguna de estas cuatro:

- el archivo no entra cómodo en memoria,
- recolectás periódicamente y querés agregar sin releer todo,
- necesitás cruzar dos tablas,
- querés evitar duplicados de forma confiable.

SQLite es una base entera en un solo archivo. No hay servidor ni contraseñas. Ver clase 4.

### Corrí el scraper dos veces y tengo todo duplicado

Te faltó un identificador estable. Guardá siempre un `id` propio de cada registro
(suele estar en la URL) y deduplicá con `distinct(id, .keep_all = TRUE)`.

Con id, es un problema de dos líneas. Sin id, es un problema de tarde entera.

---

## Método

### ¿Puedo scrapear este sitio?

Contestá las diez preguntas de
[`../clase-04-etica-y-proyecto/recursos/checklist-etico-legal.md`](../clase-04-etica-y-proyecto/recursos/checklist-etico-legal.md).

La versión corta: **público no quiere decir libre**, y hay tres planos distintos —
técnico (¿podés?), contractual (¿te dejan?) y legal (¿corresponde?).

### ¿Qué escribo en el apartado metodológico?

Seis líneas: fuente, período de recolección, criterio de inclusión, herramienta y versiones,
volumen obtenido y depurado, y limitaciones.

La última es la que más se omite y la que más credibilidad da.

### El sitio cambió y mi scraper dejó de andar

Va a pasar. Por eso el pipeline de la clase 4 **imprime cuántos registros trajo**: un cero
salta a la vista, un error silencioso no.

Buscá el selector nuevo, cambialo en `CONFIG`, y **anotalo en la bitácora**. Tu corpus tiene
una costura ahí y vas a necesitar poder explicarla.

### ¿Y si el dato está en PDF?

Eso ya no es scraping. Mirá `pdftools` para PDF de texto, y `tesseract` para escaneados.
Es otro tema, y bastante más largo.
