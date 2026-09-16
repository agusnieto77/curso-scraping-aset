# Chuleta de stringr

Todas las funciones empiezan con `str_` y toman el texto como primer argumento,
así que encadenan bien con el pipe `|>`.

## Limpiar

| Función | Qué hace |
|---|---|
| `str_squish(x)` | saca espacios al principio, al final y los repetidos del medio |
| `str_trim(x)` | saca espacios solo en los extremos |
| `str_to_lower(x)` | pasa todo a minúscula |
| `str_to_title(x)` | Pone En Mayúscula Cada Palabra |
| `str_remove(x, patron)` | borra la primera coincidencia |
| `str_remove_all(x, patron)` | borra todas |
| `str_replace(x, patron, nuevo)` | reemplaza la primera |
| `str_replace_all(x, patron, nuevo)` | reemplaza todas |

`str_squish()` es la que más vas a usar. El HTML viene lleno de saltos de línea
y sangría que no son parte del dato.

## Buscar

| Función | Devuelve |
|---|---|
| `str_detect(x, patron)` | `TRUE` / `FALSE` — ¿está o no? |
| `str_extract(x, patron)` | el primer trozo que coincide, o `NA` |
| `str_extract_all(x, patron)` | todos los trozos, como lista |
| `str_count(x, patron)` | cuántas veces aparece |
| `str_starts(x, patron)` / `str_ends(x, patron)` | empieza / termina con |
| `str_length(x)` | cuántos caracteres tiene |

**El error más común:** buscar sin normalizar mayúsculas.

```r
str_detect("Trabajo Registrado", "trabajo")            # FALSE
str_detect(str_to_lower("Trabajo Registrado"), "trabajo")  # TRUE
```

## Expresiones regulares, lo mínimo

Un patrón es una descripción de forma, no un texto literal.

| Patrón | Coincide con |
|---|---|
| `"empleo"` | la palabra empleo, tal cual |
| `"empleo\|trabajo"` | empleo **o** trabajo (la barra es "o") |
| `"[0-9]"` | un dígito cualquiera |
| `"[0-9]+"` | uno o más dígitos seguidos |
| `"[a-z]+"` | una o más letras minúsculas |
| `"."` | cualquier carácter |
| `"[.]"` | un punto literal |
| `"^casa"` | empieza con "casa" |
| `"casa$"` | termina con "casa" |
| `"a?"` | una "a", opcional |
| `"[^/]+"` | uno o más caracteres que **no** sean barra |

### Sobre las barras invertidas

En muchos lenguajes un dígito se escribe `\d`. En R, dentro de un texto entre
comillas, la barra invertida hay que escribirla **dos veces**: `"\d"`.

Es una fuente inagotable de errores, así que en el curso preferimos `"[0-9]"`,
que significa lo mismo y no necesita ninguna barra.

### Mirar hacia atrás

```r
str_extract("https://www.eldia.com/deportes/nota", "(?<=eldia[.]com/)[^/]+")
#> "deportes"
```

`(?<= ... )` dice "lo que sigue a esto, sin incluirlo". Sirve para sacar la parte
de una URL que viene después de algo conocido.

## Probar antes de usar

Escribí el patrón sobre un ejemplo suelto antes de aplicarlo a toda la columna:

```r
ejemplo <- "Paritarias 2026: aumento del 12,5% para el gremio"

str_extract(ejemplo, "[0-9]+(?:[.,][0-9]+)?%")   # "12,5%"
str_detect(ejemplo, "paritaria")                  # FALSE — ojo, mayúscula
str_detect(str_to_lower(ejemplo), "paritaria")    # TRUE
```

Si el patrón no anda sobre un caso, no va a andar sobre mil.

## Para seguir

- Hoja de referencia oficial: https://rstudio.github.io/cheatsheets/strings.pdf
- *R for Data Science*, cap. 14–15: https://r4ds.hadley.nz/strings
- Probador interactivo de expresiones regulares: https://regex101.com (elegí "PCRE")
