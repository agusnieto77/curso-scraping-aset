# Chuleta de selectores CSS

Un selector es la **dirección** de un elemento dentro de la página.
Es lo que le pasás a `html_element()` o `html_elements()`.

## Lo básico

| Selector | Qué agarra | Ejemplo de HTML |
|---|---|---|
| `p` | todos los párrafos | `<p>...</p>` |
| `.nota` | todo lo que tenga la **clase** `nota` | `<div class="nota">` |
| `#resumen` | el elemento con **id** `resumen` (hay uno solo por página) | `<table id="resumen">` |
| `article.destacada` | los `<article>` que **además** tienen clase `destacada` | `<article class="nota destacada">` |

> Regla mnemotécnica: **punto = clase, numeral = id**.

## Combinar

| Selector | Qué agarra |
|---|---|
| `.nota a` | los enlaces que están **en algún lugar dentro** de `.nota` |
| `.nota > a` | los enlaces que son **hijos directos** de `.nota` |
| `h2, h3` | los `h2` **y** los `h3` (la coma es "o") |
| `.nota:first-child` | el primero de su grupo |
| `a[href]` | los enlaces que tienen atributo `href` |
| `a[href^="/notas"]` | los enlaces cuyo `href` **empieza con** `/notas` |

## Singular vs. plural

```r
html_element("h1")    # el PRIMERO. Devuelve 1 resultado.
html_elements("h1")   # TODOS. Devuelve un vector.
```

Usá el singular cuando sabés que hay uno solo, o cuando estás recorriendo
elementos uno por uno y querés que los NA se mantengan alineados.

## Sacar el contenido

```r
html_text2()          # el texto visible, con los espacios limpios
html_text()           # el texto crudo, tal cual está en el HTML
html_attr("href")     # el valor de un atributo
html_attrs()          # todos los atributos, como lista
html_table()          # convierte una <table> en data frame
```

`html_text2()` es casi siempre la que querés. `html_text()` te deja los saltos
de línea y la sangría del código fuente adentro del dato.

## Cómo encontrar el selector en un sitio real

1. Abrí la página en Chrome o Firefox.
2. Botón derecho sobre el dato que querés → **Inspeccionar**.
3. Mirá la etiqueta resaltada y sus clases.
4. Botón derecho sobre esa línea → **Copy → Copy selector**.

**Cuidado con el paso 4.** El navegador te da algo como
`#root > div:nth-child(3) > div > div.wrapper > article:nth-child(1) > h2`.
Eso funciona hoy y se rompe la semana que viene, porque describe una posición
exacta en el árbol.

Preferí siempre la clase con nombre propio: `.nota__titulo-item`. Esa clase
existe porque alguien la eligió para significar algo, y por eso dura más.

## Cuándo hace falta XPath

CSS no puede seleccionar por **texto contenido** ni subir hacia el padre.
Para eso está XPath, que vemos en la clase 2:

```r
html_elements(xpath = "//a[contains(text(), 'convenio')]")
```

Si CSS te alcanza, usá CSS. Es más corto y más legible.
