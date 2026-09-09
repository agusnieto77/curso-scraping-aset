# Introducción al Web Scraping con R

**Recolección automatizada de datos para la investigación social**
ASET — Asociación Argentina de Especialistas en Estudios del Trabajo · 2026

Curso virtual sincrónico · 4 encuentros de 2 horas · Docente: Agustín Nieto (CONICET)

---

## Antes del primer encuentro

1. Instalá R y RStudio siguiendo [`INSTALACION.md`](INSTALACION.md).
2. Descargá esta carpeta completa.
3. Abrí **`curso-scraping-aset.Rproj`** haciendo doble clic. Siempre trabajamos desde ahí:
   eso hace que todas las rutas de los scripts funcionen sin que tengas que tocar nada.
4. Corré `clase-01-fundamentos/scripts/01-verificar-entorno.R`. Si termina sin errores, estás listo.

> Si algo falla, escribilo en el canal de consultas antes del encuentro. No lo dejes para el día.

## Cómo está organizado

El curso tiene 4 encuentros. Este repositorio se actualiza clase a clase.

```
clase-01-fundamentos/          La web como fuente de datos
comun/                         Instalación de paquetes y código compartido
docs/                          Glosario, bibliografía y preguntas frecuentes
```

Dentro de cada clase:

| Carpeta | Qué contiene |
|---|---|
| `README.md` | Guion del encuentro, ejercicios y desafíos |
| `scripts/` | Los scripts, numerados en el orden en que se usan |
| `datos/crudo/` | Copias de las páginas descargadas (respaldo por si el sitio se cae) |
| `datos/salida/` | Lo que producen los scripts. Se puede borrar sin miedo |
| `recursos/` | Chuletas y material de apoyo |

## Cómo leer los scripts

Todos empiezan con el mismo encabezado: qué hace, qué necesita y qué produce.
Están pensados para leerse de arriba hacia abajo, sin saltos.

Podés ejecutarlos línea por línea con `Ctrl + Enter` (`Cmd + Enter` en Mac).
**Hacelo así la primera vez.** Correr todo de una no enseña nada.

## Un acuerdo sobre el alcance

Este curso enseña a recolectar datos publicados de forma abierta, con criterio técnico y
responsabilidad metodológica. **No enseña a evadir bloqueos, CAPTCHAs ni restricciones de acceso.**

Cuando un sitio te bloquea te está diciendo algo. En la clase 3 y en la 4 trabajamos qué hacer
a partir de ahí: APIs públicas, sitemaps, portales de datos abiertos y pedidos formales de acceso.
Casi siempre hay una puerta abierta al lado de la ventana que estabas por forzar.

## Si algo no funciona

Antes de escribir al canal, mirá [`docs/preguntas-frecuentes.md`](docs/preguntas-frecuentes.md).
Están los tropiezos más comunes: rutas, acentos, selectores que no coinciden, bloqueos.

## Documentación

- [`docs/glosario.md`](docs/glosario.md) — HTML, DOM, selector, request, API, JSON...
- [`docs/preguntas-frecuentes.md`](docs/preguntas-frecuentes.md) — errores comunes y cómo salir
- [`docs/bibliografia.md`](docs/bibliografia.md) — referencias y fuentes usadas
