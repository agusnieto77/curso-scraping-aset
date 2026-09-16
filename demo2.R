library(rvest)
library(tibble)

url <- "https://search.scielo.org/?q=trabajadores&lang=es&count=100&from=1"
html <- read_html(url)
html_live <- read_html_live(url)

indice <- tibble(
  titulo = html_text2(html_elements(html_live, "strong.title")),
  url    = html_attr(html_elements(html_live, xpath = '/html/body/section/div/div/div[1]/div[2]/div[3]/div/div[2]/div[1]/a'), "href")
)

url_local <- "./Búsqueda _ SciELO.html"
html_local <- read_html(url_local)

indice_local <- tibble(
  titulo = html_text2(html_elements(html_local, "strong.title")),
  url    = html_attr(html_elements(html_local, xpath = '/html/body/section/div/div/div[1]/div[2]/div[3]/div/div[2]/div[1]/a'), "href")
)

html_text2(html_elements(read_html(indice_local$url[1]), ".title"))

html_text2(html_elements(read_html(indice_local$url[1]), ".body"))