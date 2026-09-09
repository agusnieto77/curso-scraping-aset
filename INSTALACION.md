# Instalación del entorno

Hacé esto **una semana antes del primer encuentro**. Si algo falla, tenés tiempo de resolverlo.

---

## 1. Instalar R

R es el lenguaje. Es lo que hace el trabajo.

- **Windows / Mac / Linux:** https://cran.r-project.org
- Necesitás **R 4.3 o superior**. Si ya tenés R instalado pero es más viejo, actualizalo.

En Windows, instalá también **Rtools** (te lo ofrece la misma página de CRAN).
Algunos paquetes lo necesitan para compilarse.

## 2. Instalar RStudio

RStudio es el entorno de trabajo: el editor donde vas a escribir y correr el código.
R sin RStudio funciona, pero es incómodo.

- https://posit.co/download/rstudio-desktop/ → **RStudio Desktop**, versión gratuita.

> Si ya usás **Positron**, también sirve. El curso no depende de cuál elijas.

## 3. Abrir el proyecto

Doble clic en **`curso-scraping-aset.Rproj`**.

Esto es importante y vale la pena entender por qué: al abrir el `.Rproj`, RStudio se posiciona
en la carpeta del curso. Todos los scripts usan rutas relativas a esa carpeta
(por ejemplo `clase-01-fundamentos/datos/salida/titulos.csv`).

Si abrís los scripts sueltos, sin el proyecto, las rutas no van a encontrar nada.

## 4. Instalar los paquetes

Con el proyecto abierto, en la consola de RStudio escribí:

```r
source("comun/R/instalar-paquetes.R")
```

Va a tardar unos minutos la primera vez. Es normal.

## 5. Verificar

```r
source("clase-01-fundamentos/scripts/01-verificar-entorno.R")
```

Si ves el mensaje final `Entorno listo`, terminaste.

---

## Problemas frecuentes

**"No tengo permisos para instalar paquetes"**
Suele pasar en computadoras de trabajo. R te va a ofrecer instalar en una biblioteca personal:
aceptá. Si no lo ofrece, corré `dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE)` y volvé a intentar.

**"El paquete `chromote` no instala"**
No te preocupes ahora. Solo se usa en una demostración de la clase 3, y la vas a poder seguir igual.

**"Error de compilación"**
En Windows casi siempre falta Rtools (paso 1). En Mac, abrí la Terminal y corré
`xcode-select --install`.

**Los acentos se ven mal (`Ã©`, `Â°`)**
Es un problema de codificación. En RStudio: `Tools → Global Options → Code → Saving →
Default text encoding: UTF-8`. Después reabrí el archivo.
