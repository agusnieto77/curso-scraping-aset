# Clase 1 — La web como fuente de datos: fundamentos y primeros pasos

**Duración:** 2 horas
**Objetivo:** que termines la clase con un CSV propio, extraído de un sitio real, y
entendiendo qué hiciste en cada línea.

> No hace falta que sepas programar en R para seguir esta clase. Sí hace falta que
> tengas el entorno instalado: ver [`../INSTALACION.md`](../INSTALACION.md).

---

## Antes de la clase

1. Abrí `curso-scraping-aset.Rproj`.
2. Corré `scripts/01-verificar-entorno.R`.
3. Si algo falla, escribilo en el canal de consultas.

> Al cargar los paquetes vas a ver mensajes como *"The following object is masked..."*.
> Son avisos normales, no errores. R te está diciendo que dos paquetes tienen una función
> con el mismo nombre y que va a usar la del último que cargaste.

---

## Guion del encuentro

| Bloque | Min | Qué hacemos |
|---|---|---|
| **A** | 30 | **Demo de apertura**: el recorrido completo en vivo. → `00-demo-apertura.R` · Qué es y qué no es el scraping. Ronda: qué quiere recolectar cada uno. |
| **B** | 30 | Anatomía de una página: HTML, CSS y el árbol DOM. Inspeccionar en el navegador. → `02-anatomia-de-una-pagina.R` |
| **C** | 20 | HTTP en veinte minutos: GET, códigos de estado, `User-Agent`. Demostración en vivo de un sitio que bloquea. |
| **D** | 40 | **Primer scraping real** sobre la portada de El Día. → `03-primer-scraping-eldia.R` |
| **E** | 10 | Cierre y tarea. |

### Bloque A — La demo de apertura

Arranca corriendo `scripts/00-demo-apertura.R` línea por línea, **sin explicar el código**.
El objetivo es que vean el recorrido entero y que ninguno de los seis pasos parece difícil.

El momento importante es el principio: `read_html()` sobre computrabajo **falla con un 403**,
y `read_html_live()` sobre la misma URL funciona. Ahí está la idea de toda la clase:
*lo que ve tu navegador no es lo que ve R.*

Y ahí queda planteada la pregunta que abre la clase 4, sin contestarla todavía:

> El primer intento falló porque el sitio no quiso atendernos.
> El segundo funcionó porque golpeamos distinto.
> **¿Alcanza con que funcione?**

### Qué es el scraping

Scraping es extraer de forma automatizada información **ya publicada** en la web para
convertirla en datos estructurados.

Tres cosas que **no** es:
- No es hackear. No entrás a ningún lado al que no pueda entrar cualquiera con un navegador.
- No es magia. Si el dato no está en la página, no lo vas a poder sacar de la página.
- No es siempre la respuesta. Si hay una API o un archivo descargable, ese es el camino.

Y una que sí es: **una decisión metodológica**. Elegís una fuente, un recorte y un momento.
Eso hay que poder justificarlo igual que cualquier otra técnica de construcción de datos.

### Bloque C — El sitio que dice que no

Vamos a pedirle su `robots.txt` a dos portales de empleo:

```r
# Este responde 403: no atiende programas automáticos, ni siquiera para leer sus reglas.
httr2::request("https://ar.computrabajo.com/robots.txt") |>
  httr2::req_error(is_error = \(resp) FALSE) |>
  httr2::req_perform()

# Este responde 200, y además publica sus sitemaps.
httr2::request("https://www.zonajobs.com.ar/robots.txt") |> httr2::req_perform()
```

Dos portales del mismo rubro, dos respuestas opuestas. Guardá esa diferencia:
la retomamos en la clase 3, y ahí resuelve un problema concreto.

---

## Scripts

| Archivo | Qué enseña | Internet |
|---|---|---|
| `00-demo-apertura.R` | **Demo docente.** El recorrido completo en vivo, sin explicar nada. | sí |
| `01-verificar-entorno.R` | Que todo esté instalado. Se corre **antes** de la clase. | opcional |
| `02-anatomia-de-una-pagina.R` | Leer HTML, selectores CSS, texto vs. atributos, tablas. | no |
| `03-primer-scraping-eldia.R` | Un scraping completo de punta a punta, sobre un sitio real. | sí (con respaldo) |

Corrélos **línea por línea** con `Ctrl + Enter`. Mirá cada resultado antes de pasar al siguiente.

---

## Ejercicio de cierre

Sobre `03-primer-scraping-eldia.R`:

1. Extraé también los copetes de la portada (clase `.nota__introduccion`).
2. Contá cuántos hay y comparalo con la cantidad de títulos.
3. **Respondé**: ¿podrías pegar ambos vectores en la misma tabla tal como están? ¿Qué pasaría?

Esa pregunta es el puente a la clase 2.

## Desafío (si ya te movés con R)

Repetí el script 3 sobre `https://www.cba24n.com.ar`.

El selector `.nota__titulo-item` no va a funcionar: cada sitio inventa sus propias clases.
Inspeccioná la página, encontrá el selector correcto y adaptá el script.

Ese trabajo — abrir el inspector y buscar el selector — es literalmente el 80% del scraping real.

## Tarea para la clase 2

Elegí **un sitio propio**, de los que te interesan para tu investigación, e identificá:

1. Tres selectores de datos que quieras extraer.
2. Si el contenido aparece en el HTML o lo carga JavaScript.
   (Para saberlo: botón derecho → *Ver código fuente de la página*. Si tu dato **no** está ahí,
   lo carga JavaScript. No es un problema, es información: lo resolvemos en la clase 3.)
3. Qué dice su `robots.txt`.

Traelo anotado. Lo usamos en clase.

---

## Recursos

- [`recursos/chuleta-selectores.md`](recursos/chuleta-selectores.md) — referencia rápida de selectores CSS
- [`recursos/pagina-ejemplo.html`](recursos/pagina-ejemplo.html) — abrila en un editor de texto mientras corrés el script 2
- [`../docs/glosario.md`](../docs/glosario.md) — todos los términos del curso
