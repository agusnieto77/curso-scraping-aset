# Glosario

Términos que vas a escuchar en el curso. Cortos, sin vueltas.

**HTML** — El lenguaje con el que se escriben las páginas web. No es un lenguaje de
programación: es un lenguaje de *marcado*. Etiqueta el contenido para decir qué es cada cosa
(`<h1>` esto es un título, `<p>` esto es un párrafo).

**Etiqueta (tag)** — Cada una de esas marcas: `<p>`, `<a>`, `<article>`, `<table>`.
Casi siempre vienen de a pares: una que abre y una que cierra (`<p>` ... `</p>`).

**Atributo** — Información extra dentro de una etiqueta. En `<a href="/notas/x">`, el `href`
es un atributo y `/notas/x` su valor. Los enlaces, las imágenes y las fechas suelen vivir en
atributos, no en el texto visible.

**Clase** — Una etiqueta con nombre que se le pone a uno o varios elementos para agruparlos:
`<article class="nota">`. Es lo que más vas a usar para seleccionar.

**id** — Como la clase, pero único: solo un elemento por página puede tenerlo.

**DOM** — *Document Object Model*. El HTML no es una lista de líneas sino un **árbol**: el
`<body>` contiene `<div>`, que contiene `<article>`, que contiene `<h2>`. El DOM es ese árbol.
Cuando hacés scraping estás caminando por él.

**CSS** — El lenguaje que define cómo se ve la página. Nos importa por sus **selectores**:
la sintaxis para apuntar a un elemento (`.nota__titulo`).

**Selector** — La dirección de un elemento en el árbol. Ver `chuleta-selectores.md`.

**XPath** — Otro lenguaje de selección, más potente y más incómodo que CSS. Sirve para lo que
CSS no puede: buscar por texto contenido o subir hacia el elemento padre.

**HTTP** — El protocolo con el que tu navegador (o R) le pide páginas a un servidor.

**Request / Response** — El pedido y la respuesta. Vos mandás un request, el servidor devuelve
un response con el HTML adentro.

**GET / POST** — Los dos tipos de pedido que usamos. `GET` pide una página. `POST` además le
manda datos al servidor: es lo que pasa cuando completás un formulario de búsqueda.

**Código de estado** — El número con el que responde el servidor:
- `200` — Todo bien, acá está.
- `301` / `302` — Se mudó, buscalo en otro lado (R lo sigue solo).
- `403` — Prohibido. Sé quién sos y no te voy a atender.
- `404` — No existe.
- `429` — Estás pidiendo demasiado rápido. Frená.
- `500` — Se rompió algo del lado del servidor.

**User-Agent** — Una cadena de texto que identifica a quien pide. Tu navegador manda la suya;
R manda otra. Muchos sitios deciden qué responderte a partir de eso.

**API** — *Application Programming Interface*. Una puerta que el sitio abre a propósito para
que un programa le pida datos, normalmente en JSON. Cuando hay API, se usa la API: es más
estable, más rápida y no hay que discutir si corresponde.

**JSON** — Un formato de texto para intercambiar datos estructurados. Es lo que devuelven casi
todas las APIs. En R se lee con `jsonlite`.

**robots.txt** — Un archivo en la raíz del sitio (`ejemplo.com/robots.txt`) donde el sitio
declara qué zonas prefiere que los programas automáticos no recorran. No es una ley ni un
candado: es una declaración de intención. Ignorarla es una decisión, y hay que poder justificarla.

**Sitemap** — Un archivo XML donde el sitio lista sus propias URLs para que los buscadores las
encuentren. Cuando existe, suele ser el camino más limpio para recorrer un sitio entero.

**Renderizado del lado del cliente** — Páginas donde el HTML llega casi vacío y el contenido lo
arma JavaScript en tu navegador. Ahí `read_html()` no ve nada, porque R no ejecuta JavaScript.
Se resuelve con `chromote` (clase 3) o buscando la API que el sitio consulta por detrás.

**Paginación** — Cuando un listado se reparte en muchas páginas (`?page=1`, `?page=2`).
Recorrerlas es el primer paso para escalar (clase 3).

**Scraping** — Extraer de forma automatizada información publicada en la web para
estructurarla como datos. Nada más, y nada menos.
