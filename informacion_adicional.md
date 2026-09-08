# Información adicional — Conabio-PGMaices

Notas para quien (persona o agente) vaya a **desplegar, mantener o modificar** esta app.
Recogen problemas que ya se encontraron y se resolvieron, y trampas que **no producen
ningún error visible** — ni en el log de Shiny ni en la consola del navegador — así que
son imposibles de descubrir leyendo el código.

**Léelo completo antes de publicar en el servidor.** La sección 1 es la más importante:
describe un fallo que hace que la app se vea *distinta* en el servidor que en tu máquina,
sin avisar de nada.

Última actualización: 7 de septiembre de 2026.

---

## 1. ⚠️ El locale: lo primero que hay que revisar al desplegar

**Si el servidor no arranca en UTF-8, la app pierde el 52.5% de los colores del mapa y
no emite un solo error.**

### Qué pasa

Los datos vienen de un `.xlsx` y traen sus cadenas marcadas con `Encoding() == "UTF-8"`.
Los literales escritos dentro de `global.R` (`"Cónico"`, `"Tuxpeño"`, `"Chalqueño"`…)
quedan marcados como `"unknown"`. En un locale UTF-8 R los compara sin problema. **En un
locale `C` o Latin-1, no los considera iguales aunque los bytes sean idénticos.**

Comprobado: los bytes de `"Cónico"` en los datos y en el literal son exactamente los
mismos — `43 c3 b3 6e 69 63 6f` — y aun así `"Cónico" %in% names(razas_por_complejo)`
devuelve `FALSE` en locale `C`.

### Qué se rompe, en concreto

Todo lo que dependa de comparar un literal acentuado con un valor de los datos:

| Qué | Consecuencia en locale no-UTF-8 |
|---|---|
| `RatingCol` (colores del mapa, `global.R:62-100`) | **11,233 de 21,408 registros** (52.5%) se quedan sin color y salen **negros**. Afecta a las 14 razas con acento o ñ: Cónico, Cónico Norteño, Chalqueño, Elotes Cónicos, Mixeño, Olotón, Onaveño, Palomero Toluqueño, Quicheño, Ratón, Tuxpeño, Tuxpeño Norteño, Uruapeño, Vandeño |
| `revalue` de `Complejo_racial` (`global.R:51-52`) | "Cónico" no se convierte en "Cónicos" y "Chapalote" no se convierte en "Chapalotes" |
| `razas_por_complejo` | El resaltado por complejo racial de la pestaña de Altitud no resalta nada |
| Títulos y subtítulos de las gráficas | "maíz" sale como "ma..z", "montaña" como "monta..a" |

Los nombres que vienen **de los datos** (las etiquetas de cada raza en la montaña) se ven
bien siempre, porque cargan su marca UTF-8. Sólo fallan los literales del código. Eso hace
el síntoma especialmente confuso: media figura correcta y media rota.

### La solución — YA IMPLEMENTADA (7 de septiembre de 2026)

`global.R` abre con un bloque `local({...})` que va **antes que nada**, incluso antes de
los `library()`, porque tiene que estar activo antes de leer el primer dato.

No es un `Sys.setlocale()` suelto: si el sistema ya está en UTF-8 **no hace nada**, y si no
lo está prueba varios nombres en orden (`es_MX.UTF-8`, `en_US.UTF-8`, `C.UTF-8` y sus
variantes `.utf8`) hasta que uno funcione. Es necesario porque los nombres disponibles
cambian según el sistema: `es_MX.UTF-8` suele no existir en Linux, donde lo seguro es
`C.UTF-8`. Si ninguno funciona, emite un `warning` explicando qué se va a romper.

Verificado arrancando con `LC_ALL=C`, que antes dejaba 11,233 registros sin color: ahora
promueve el locale a UTF-8 y quedan **0**.

En un `Dockerfile`, conviene además:

```dockerfile
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
```

### Cómo verificarlo sin abrir la app

```r
LC_ALL=C Rscript -e 'source("global.R"); sum(!grepl("^#[0-9A-Fa-f]{6}$", TableL$RatingCol))'
```

Debe devolver **0**. Si devuelve 11233, el locale está mal.

---

## 2. ⚠️ El mapa base: NO volver a CartoDB

El fondo es de **Esri**, no de CARTO. No es una preferencia estética.

**CARTO empezó a estampar la leyenda "API KEY REQUIRED" dentro del PNG** de sus teselas
gratuitas. Es un fallo traicionero:

- La tesela responde **HTTP 200** y es una imagen válida. **No hay error que capturar**,
  ni en la consola del navegador ni en el log de Shiny.
- La única señal es la leyenda atravesada en el fondo del mapa.
- **En local puedes verlo limpio por caché** mientras a los usuarios les sale la marca.
  Para comprobarlo de verdad hay que abrirlo en **ventana de incógnito**.

Si alguien vuelve a poner `providers$CartoDB.*` o `addProviderTiles("CartoDB.Positron")`,
el problema regresa.

### Dos detalles del fondo de Esri que no son opcionales

1. **Son DOS capas, no una.** A diferencia de CARTO, Esri separa el mapa base de los
   nombres de lugares. Por eso van `Esri.WorldGrayCanvas` **y encima**
   `World_Light_Gray_Reference`, las dos con `group = "Mapa"` para que se enciendan y
   apaguen juntas. Si se omite la segunda, el mapa queda **sin un solo nombre** de ciudad
   ni de estado.
2. **`maxNativeZoom = 16` es obligatorio.** Esas teselas no existen más allá del nivel 16.
   Sin ese parámetro, al acercarse más el fondo **se queda en blanco**. Con él, leaflet
   estira la tesela del z16 — se ve borrosa, pero se ve — y para el detalle real está la
   capa de "Foto aérea".

---

## 3. ⚠️ `levels()` sobre una columna `character` devuelve `NULL`

Este error ya causó **dos** fallos silenciosos en esta app, y va a volver a pasar porque
las columnas de `TableL` y de `Parientes` son `character`, no `factor`.

`selectInput(choices = levels(TableL$Raza_primaria))` no da error: simplemente crea un
desplegable **vacío**.

Casos que había:

| Dónde | Efecto |
|---|---|
| Selector "Raza Primaria" del mapa | Sólo ofrecía la opción "All" y nada más |
| Casillas de "Parientes Silvestres" | **No dibujaba ninguna casilla**, así que los 1,013 registros de parientes silvestres (599 teocintles + 414 tripsacum, todos con coordenadas) eran inalcanzables desde la interfaz |

**Regla:** usar `sort(unique(x))` para columnas `character`. `levels()` sólo sirve si la
columna es factor de verdad — como `Mex3$Estado`, que se convierte a propósito en
`global.R`.

---

## 4. Paquetes retirados de CRAN

Dos paquetes que la app cargaba ya no existen para R moderno. **No intentes instalarlos**:
el mensaje "package is not available for this version of R" no es un problema de tu
instalación.

| Paquete | Situación | Qué se hizo |
|---|---|---|
| `rgdal` | Retirado de CRAN en octubre de 2023 | Se borró el `library(rgdal)`. **No se usaba**: no había ni un `readOGR` ni un `spTransform` en toda la app |
| `ggalt` | Archivado en CRAN (dependía de `proj4`) | Sólo aportaba `geom_dumbbell()`. Altitud se sustituyó por el perfil de montaña y Tamaño de mazorca por los elotes acostados; **queda una llamada pendiente** en `plot11` (ver sección 7) |

---

## 5. `shinydashboardPlus` 2.0 borró todas las funciones `*Plus`

La app estaba escrita para la versión 1.x. La 2.0 renombró funciones y argumentos. Si
aparece `could not find function "dashboardPagePlus"`, es esto.

| 1.x | 2.0.6 |
|---|---|
| `dashboardPagePlus()` | `dashboardPage()` |
| `sidebar_background =` | *(argumento eliminado)* |
| `dashboardHeaderPlus()` | `dashboardHeader()` |
| `boxPlus()` | `box()` |
| `userPostMedia(src =)` | `userPostMedia(image =)` |
| `enable_sidebar` + `sidebar_width` + `sidebar_start_open` + `sidebar_content` | `sidebar = boxSidebar(id=, width=, startOpen=, ...)` |
| `widgetUserBox(title=, subtitle=, src=, type=, color=)` | `userBox(title = userDescription(title=, subtitle=, image=, type=), status=)` |
| `socialButton(url=, type="github")` | `socialButton(href=, icon = icon("github"))` |

⚠️ **El orden de los `library()` importa.** `box()`, `dashboardPage()` y
`dashboardHeader()` existen en `shinydashboard` **y** en `shinydashboardPlus`. Funciona
porque `ui.R` carga `shinydashboardPlus` **después** (línea 4) y lo enmascara. Si alguien
invierte ese orden, `closable` y `sidebar` empiezan a fallar.

⚠️ El `boxSidebar` de la 2.0 **exige un `id`** para poder abrirse y cerrarse.

### ⚠️ El `boxSidebar` de la 2.0 SE SUPERPONE al contenido; en la 1.x lo empujaba

Este cambio costó una tarde de diagnóstico equivocado. En la pestaña "Diversidad de
maíces" el selector de raza vivía en un `boxSidebar` con `startOpen = TRUE`, y en la 2.0
ese panel queda **encima** del cuerpo de la caja, tapando su tercio derecho.

El síntoma: la gráfica de registros por estado parecía **cortada**, con la barra mayor
pegada al borde y sin su etiqueta, y el eje X sin sus últimas marcas. Todo apuntaba a un
problema de límites del eje.

Lo engañoso es que **no había nada mal en la gráfica**. Midiendo en el DOM, la etiqueta y
la marca faltantes estaban dibujadas y en su posición correcta (x = 1127 y x = 1077);
simplemente caían debajo de un panel opaco que empezaba en x = 957. Se perdió tiempo
tocando `expand`, `limits` y el tamaño del SVG, y descartando el caché del navegador,
antes de mirar lo que había encima.

**Regla:** si una gráfica dentro de una `box()` aparece cortada por la derecha, comprueba
primero si esa caja tiene un `boxSidebar` abierto. La solución aquí fue sacar el selector
a una `column(width = 3)` propia — que además es mejor diseño, porque el control principal
de la pestaña no debería estar escondido en un panel deslizante.

---

## 6. Filtros del mapa: `datamods`, no `observeEvent`

Los cuatro filtros categóricos (complejo, raza, estado, proyecto) se cruzan solos con dos
llamadas a `datamods`: `select_group_ui()` en `ui.R` y `select_group_server()` en
`server.R`. Antes eran **450 líneas** de `observeEvent` cubriendo a mano las 15
combinaciones posibles de 4 filtros.

Si mañana hace falta un quinto filtro, se agrega una entrada a `params` y otra a `vars_r`.
No hay que tocar nada más.

### Trampas de la API

- Se llama **directo**, sin `callModule`.
- Los argumentos son `data_r` y `vars_r`, y el sufijo `_r` no es decorativo: **hay que
  envolverlos en `reactive()`**. Pasarles el data frame pelón falla.
- La etiqueta va en `label`, **no en `title`** — `datamods` ignora `title` en silencio y
  los filtros salen sin etiqueta.
- Es `btn_reset_label`, no `btn_label`.
- `dropboxWidth` es necesario porque el panel es angosto (13%); sin él los nombres largos
  salen truncados.

### Cambio de comportamiento

Ya **no existe la opción literal "All"**. Dejar un filtro vacío significa "no filtrar por
esta columna", y ahora se pueden elegir **varios valores a la vez** en el mismo filtro. Si
algún texto de la app menciona "All", hay que actualizarlo.

El deslizador de altitud va **aparte**, aplicado encima de los filtros de `datamods` en
`points()`: el módulo sólo maneja columnas categóricas.

---

## 6b. El Sankey va en D3, no en Google Charts

La gráfica de aluvial usaba `gvisSankey()` de **googleVis**, que no es D3: inyecta
`https://www.gstatic.com/charts/loader.js` y dibuja con Google Charts. Se sustituyó por
**D3 + d3-sankey**, servidos desde el propio `www/js/`.

Las tres razones, en orden de importancia:

1. **Era una dependencia externa en tiempo de ejecución.** Si el servidor o la red del
   usuario no alcanzan `gstatic.com` —redes de gobierno que filtran Google, o
   simplemente sin internet—, la gráfica no aparece y no hay error que leer.
2. **Cada visitante hacía una petición a Google.** Para un sitio de CONABIO eso es una
   consideración de privacidad, no sólo técnica.
3. `googleVis` no permitía controlar transiciones ni colores por nodo.

### Cómo está armado

| Archivo | Qué hace |
|---|---|
| `www/js/d3.v7.min.js` | D3 7.9.0, guardado en el repo |
| `www/js/d3-sankey.min.js` | d3-sankey 0.12.3 |
| `www/js/sankey-maiz.js` | El dibujo y las transiciones |
| `server.R`, `sankey_datos()` | Arma nodos y listones y los manda con `sendCustomMessage` |

Los flujos son **complejo racial → raza → estado**, y el color del listón lo da el
complejo, para poder seguirlo de punta a punta.

### ⚠️ Tres cosas que rompen si se tocan

1. **Shiny serializa los `data.frame` POR COLUMNAS** (`{id:[...], nombre:[...]}`) y D3
   espera un arreglo de filas. Por eso `sankey_datos()` convierte con la función `filas()`
   antes de enviar. Sin eso el navegador falla con `datos.nodes.map is not a function` —
   y el error sale **en la consola del navegador**, no en el log de R.
2. **El apretón de manos `input$sankey_listo` no es opcional.** Los mensajes enviados
   antes de que el JS registre su manejador **se pierden en silencio**. El cliente avisa
   cuando está listo y el servidor recién entonces manda los datos. Si se quita, la
   pestaña arranca en blanco hasta que alguien mueve el filtro.
3. **`nodeId()` es lo que hace posible la transición.** Al identificar los nodos por su id
   de texto en vez de por su índice, el data join reconoce a los supervivientes entre una
   actualización y otra y los anima a su nueva posición. Sin eso, cada cambio de filtro
   redibuja de cero.

El id de cada nodo lleva prefijo de nivel (`C|`, `R|`, `E|`) para que un nombre repetido
entre dos niveles no colapse en un solo nodo.

`library(googleVis)` quedó comentado en `server.R`: ya no se usa en ninguna parte.

---

## 6c. Tamaño de mazorca: también en D3

La pestaña pasó por tres versiones: `geom_dumbbell()` de ggalt (paquete archivado),
luego `ggiraph`, y ahora **D3**. El motivo del último cambio es que `ggiraph` reemplaza
el SVG completo en cada render y por eso **no puede animar**: al cambiar el orden o los
estados, la figura saltaba de golpe.

**El costo, que conviene tener presente:** se perdió la barra de herramientas que
`ggiraph` daba gratis — zoom, descarga en PNG y pantalla completa. Si hacen falta, hay
que construirlas a mano.

### ⚠️ Por qué todos los elotes tienen el mismo número de vértices

`www/js/mazorca-maiz.js` dibuja **siempre 60 vértices por lado y 12 hileras de granos**,
sin importar lo largo que sea el elote. No es un detalle estético: para interpolar un
contorno con otro, D3 necesita que el número de puntos del atributo `d` coincida. Si las
hileras se dibujaran "cada 1.3 cm" —como en la versión de ggplot— un elote de 10 cm
tendría 7 y uno de 25 cm tendría 19, y la transición sería imposible.

La función `anchoElote()` es idéntica en R y en JS a propósito, para que las dos versiones
de la figura se vean iguales.

### Filtro por estado

`RawData.csv` **sí trae la columna `Estado`** (la 7), aunque antes no se leía.

⚠️ **Los escribe distinto que el Excel del PGM:** en mayúsculas y **con acentos**
(`MICHOACÁN DE OCAMPO`, `NUEVO LEÓN`, `ESTADO DE MÉXICO`), mientras el Excel los trae sin
acento (`MICHOACAN DE OCAMPO`). Por eso hay una segunda función de normalización,
`normalizar_estado_raw()` en `global.R`, aparte del `revalue` de `TTabla`.

Esa función compara sobre una **clave transliterada a ASCII** con
`stringi::stri_trans_general(x, "Latin-ASCII")`, no sobre el texto acentuado. Es
deliberado: así el emparejamiento no depende del locale (ver sección 1). Los acentos
aparecen sólo del lado del **valor**, que nunca se compara. Los 31 estados empatan con los
del mapa.

### El resumen por raza ya no se precalcula

`Size5`, `Size5.1`, `Size6`, `Size7`, `Size8` y `Size9` desaparecieron de `global.R`:
ahora que el filtro por estado cambia el mínimo, el promedio y el máximo, el resumen se
arma en el `reactive()` `mazorcas()` de `server.R`. En `global.R` sólo queda `Size1` (los
registros crudos, con estado) y `estados_mazorca` para el selector.

**Consecuencia que se ve en pantalla:** al filtrar por pocos estados, más razas quedan con
un solo registro y por tanto sin rango que dibujar. El pie de la figura los nombra, para
que su ausencia no parezca un error. Con los 31 estados sólo falta Uruapeño; con cinco
estados pueden ser siete.

---

## 6d. Las cajas de la portada se igualan con CSS, no con `height`

Las seis cajas de "Visualización" quedaban desparejas porque cada una crecía con el largo
de su texto. Se resolvió como en shiny-agro-phaseolus: el `fluidRow` va envuelto en
`div(class = "visualizacion-cajas")` y `www/styles.css` aplica flexbox en tres niveles —
el renglón estira las columnas, la columna estira la caja, la caja estira su cuerpo.

**Las cajas ya NO llevan `height = 400`.** Ese alto fijo era justamente parte del problema:
forzaba una medida que el contenido a veces desbordaba. Ahora la decide el flexbox a
partir de la caja más alta del renglón.

El detalle que remata la alineación es `margin-top: auto` sobre la imagen: la empuja al
fondo del cuerpo de la caja, así que aunque un texto ocupe dos renglones y otro tres, las
imágenes quedan a la misma altura. Sin eso las cajas serían iguales pero las fotos no.

Antes de este cambio la app **no tenía ninguna hoja de estilos**; `www/styles.css` se creó
aquí y se enlaza desde `dashboardBody()` con `tags$head(tags$link(...))`.

### ⚠️ El navegador cachea `www/styles.css`

Cada vez que toques la hoja de estilos el navegador sigue sirviendo la versión vieja, y
vas a creer que tu regla está mal escrita. En la app de frijol esto causó tres confusiones
en un solo día. Recarga forzada (`Cmd+Shift+R`), o comprueba en consola qué se aplica de
verdad antes de suponer que el CSS está mal:

```js
getComputedStyle(document.querySelector('.visualizacion-cajas .box')).height
```

---

## 6e. Las fotos de las razas: `max-width`, nunca `width`

`renderImage()` sólo devuelve `src` y `alt`, sin dimensiones, así que cada foto se
dibujaba a su tamaño natural. Y los 69 JPEG del catálogo van de **159 a 1200 px de
ancho**, de modo que unas desbordaban su contenedor y ninguna coincidía con el ancho de
la gráfica de abajo.

En `www/styles.css` se usa **`max-width: 100%`, no `width: 100%`**. La diferencia importa:

- `max-width` reduce las fotos grandes hasta el ancho de la columna y deja las pequeñas a
  su tamaño real, centradas.
- `width` las haría todas del mismo ancho, pero ampliaría `Coscomatepec.jpg` (159 px)
  **4.6 veces**. Se vería borrosa.

Reparto de anchos: 5 fotos por debajo de 400 px, 31 entre 400 y 599, 32 entre 600 y 899,
1 de 900 o más. La única solución real para las muy pequeñas es conseguir mejores
originales.

El `imageOutput()` va sin `height` ni `width` fijos (antes tenía `500, 500`, que la foto
desbordaba): las dimensiones las decide el CSS.

---

## 6f. La ficha de cada raza: `renderText`, nunca `renderPrint`

La descripción de cada raza salía precedida de un `[1]` y encerrada entre comillas. Ni
uno ni otro estaban en los datos: el valor guardado empieza directamente en "Su
distribución original…" y no lleva comillas.

Los ponía **`renderPrint()`**, que muestra la *representación de consola* de R — el `[1]`
es el índice del elemento dentro del vector, y las comillas son cómo R dibuja una cadena
de texto. `renderText()` entrega la cadena tal cual y ambos desaparecen.

Es un error fácil de diagnosticar mal, porque el `[1]` parece un número de renglón que
viene de los datos.

**Regla:** `renderPrint` es para volcar objetos de R (lo que verías en la consola);
`renderText` es para mostrar texto a una persona. Con `textOutput` en la interfaz, casi
siempre quieres `renderText`.

### Dos razas sin fotografía

`Cacahuacintle` y `Choapaneco` no tienen `.jpg` en `www/` (las otras 61 sí). El
`renderImage` lleva un `validate(need(file.exists(...)))` que muestra un aviso en vez del
icono de imagen rota, para que se distinga "falta el dato" de "la app falló". Basta con
dejar los archivos en `www/` con esos nombres para que el aviso desaparezca solo.

⚠️ El `renderImage` traduce el nombre de la raza al del archivo con una cadena de doce
`if/else` que quita acentos a mano ("Cónico" → "Conico"). Funciona, pero si se agrega una
raza nueva con acento hay que añadirle su rama.

---

## 6g. ⚠️ Dos trampas de D3 que hacen parpadear las gráficas

Las dos aplican a `www/js/mazorca-maiz.js` y a `www/js/sankey-maiz.js`, y la segunda sólo
se manifiesta después de arreglar la primera.

### 1. No reconstruir el SVG cuando cambia el tamaño

El dibujo empezaba con:

```js
if (!svg || +svg.attr("height") !== alto) { inicializar(ancho, alto); }  // MAL
```

y `inicializar()` hacía `selectAll("svg").remove()`. Como el alto depende del número de
elementos (`max(560, n*17+60)` en la mazorca), **a partir de ~29 razas cada actualización
borraba el SVG y lo reconstruía**: parpadeo y pérdida total de la animación.

El síntoma despista: con pocas opciones se ve bien, porque ahí el alto se queda en el
mínimo y nunca cambia. El problema aparece justo cuando se cruza el umbral.

**Correcto:** crear el SVG una sola vez y después sólo ajustarle `width`, `height` y
`viewBox`. Los elementos sobreviven, que es lo que permite que el *data join* los anime.

### 2. La salida debe ser inmediata, sin transición

```js
g.exit().transition().duration(400).style("opacity", 0).remove();  // MAL
```

Un `.remove()` encadenado a una transición **sólo se ejecuta cuando la transición
termina**, y mientras tanto el nodo sigue en el DOM. Si llega otra actualización dentro de
esa ventana, `selectAll("g.raza")` lo vuelve a capturar en el join, le interrumpe la
transición y **le cancela la remoción**. Los nodos se acumulan invisibles y la gráfica
acaba vacía aunque el servidor esté mandando datos correctos.

**Correcto:** `g.exit().remove()`.

### 3. Los elementos que entran, ya colocados

Si un elemento nuevo deja que su atributo `d` transicione desde vacío, el contorno salta
en vez de incorporarse. Se le fija la geometría final en el `enter()` y sólo se le anima
la opacidad.

### Cómo verificar que quedó bien

En la consola del navegador, marcar el SVG y cambiar el filtro varias veces:

```js
document.querySelector('#mazorca_d3 svg').__marca = 'original';
// ...cambiar el filtro...
document.querySelector('#mazorca_d3 svg').__marca === 'original'   // debe seguir siendo true
```

Y que no haya fantasmas: el número de `g.raza` debe coincidir con los que tienen opacidad
mayor que 0.5.

---

## 7. Estado actual: qué falta

| Pendiente | Dónde | Detalle |
|---|---|---|
| Barra de herramientas de la mazorca | `www/js/mazorca-maiz.js` | Al pasar a D3 se perdieron el zoom, la descarga en PNG y la pantalla completa que daba `ggiraph`. Reconstruirlas si hacen falta |
| Panel de filtros encimado al mapa | `ui.R`, el `absolutePanel` del tab `widgets` | El panel es transparente y las etiquetas del mapa se le transparentan por detrás; cuesta leerlo |
| Falta la foto de Choapaneco | `www/` | Es la única de las 63 razas sin imagen. El `renderImage` acepta `.jpg`, `.png` y `.jpeg`, así que basta dejar el archivo con ese nombre |
| `mapDistribution.png` desactualizada | `www/` | La miniatura de la portada muestra el mapa con el fondo viejo de CARTO. (`tamanoMazorca.png` ya se regeneró) |
| Nada está en git | — | Todo el trabajo del 7 de septiembre de 2026 sigue sin `git add`: los cuatro archivos modificados, `informacion_adicional.md`, `www/js/`, `www/styles.css` y las imágenes repuestas |
| `fluidPage()` anidado en el Sankey | `ui.R`, ~línea 596 | Mismo patrón que se corrigió en "Diversidad de maíces": un `container-fluid` dentro de un `row`. Ahí no da problema visible, pero está mal |

---

## 8. La paleta de colores del mapa

El diseño es deliberado y conviene **no romperlo**: cada complejo racial tiene su familia
de color, y dentro de la familia un tono por raza.

| Complejo | Familia |
|---|---|
| Cónicos | verdes (Greens / YlGn) |
| Chapalotes | azules (GnBu) |
| Tropicales precoces | morados (BuPu) |
| Ocho hileras | rojos y naranjas (OrRd) |
| Sierra de Chihuahua | magentas (RdPu) |
| Maduración tardía | azules oscuros (YlGnBu) |
| Dentados tropicales | rojos oscuros (Reds) |

### DECISIÓN TOMADA (7 de septiembre de 2026): la paleta se queda como está

Se midió que **14 razas tienen luminancia menor a 60** y a 5 píxeles se leen como negros
indistinguibles entre sí — 4,836 registros, el 22.6% del mapa. Los casos extremos son
Comiteco (`#081d58`, 1,290 registros), Celaya (`#67000d`, 961), Ancho (`#7f0000`, 381) y
Arrocillo Amarillo (`#00441b`, 435): pertenecen a cuatro complejos distintos y sobre el
mapa son el mismo punto oscuro.

Se propuso recortar el extremo oscuro de cada rampa. **Alejandro lo rechazó, y con razón.**
Los argumentos, que conviene entender antes de volver a plantearlo:

1. **Con 63 categorías ninguna paleta funciona.** El ojo distingue con fiabilidad entre 8
   y 12 colores categóricos. El problema no es la elección de tonos: es que se le pide al
   color más resolución de la que el medio puede entregar.

2. **El propósito del mapa es mostrar DIVERSIDAD, no permitir búsquedas.** La profusión de
   colores *es* el mensaje: de un vistazo se lee "aquí hay muchísimas razas distintas".
   Reducir la paleta —por ejemplo a los 7 complejos— haría que el mapa **pareciera menos
   diverso**, justo lo contrario de lo que debe comunicar.

3. **La identificación individual ya está resuelta por otra vía.** Cada punto es clicable
   y su popup da raza, complejo, municipio, localidad, altitud, periodo y proyecto. El
   color hace el trabajo grueso; el texto, el fino.

El error de análisis fue evaluar la paleta como si fuera una clave de búsqueda ("¿de qué
raza es este punto?") cuando su función es ser una textura de variedad.

**No cambiar `RatingCol` ni proponer colorear por complejo racial.** Si alguna vez molesta
la masa oscura, las vías que no tocan los colores son agrandar el radio de los puntos o
darles un borde claro.

---|---|---|---|
| Comiteco | `#081d58` | 29 | 1,290 |
| Celaya | `#67000d` | 23 | 961 |
| Arrocillo Amarillo | `#00441b` | 51 | 435 |
| Ancho | `#7f0000` | 27 | 381 |

**Arreglo propuesto:** recortar el extremo oscuro de cada familia — muestrear cada rampa
desde el escalón 3 en vez del 1, de modo que ninguna raza baje de una luminancia ~75. Se
conservan las siete familias y el orden interno; sólo cambian 14 de las 63 razas.

---

## 9. Comprobaciones antes de publicar

```r
# 1. El locale no está rompiendo los colores (debe dar 0)
sum(!grepl("^#[0-9A-Fa-f]{6}$", TableL$RatingCol))

# 2. Los estados de los datos empatan con los de la tabla de capitales (debe dar 0)
length(setdiff(levels(Mex3$Estado), capitales_altitud$estado))

# 3. Los selectores no están vacíos (ninguno debe dar 0)
length(sort(unique(Parientes$Tipo)))   # 2: Teocintle y Tripsacum
length(razas_con_gradiente)            # 55
length(complejos_opciones)             # 7
```

Y en el navegador, **en ventana de incógnito** (para saltarse el caché de teselas):

- El fondo del mapa **no** debe tener la marca "API KEY REQUIRED".
- Deben verse los nombres de ciudades sobre el fondo gris.
- Al hacer zoom más allá del nivel 16 el fondo debe verse borroso, **no en blanco**.
- Los títulos de las gráficas deben decir "maíz" y "montaña", no "ma..z" ni "monta..a".
- Las casillas de Teocintle y Tripsacum deben existir, y al marcarlas los puntos deben
  aparecer **una sola vez** (si salen dobles, alguien reintrodujo el `leafletProxy`).

---

## 10. Notas sobre los datos

- `Mex3` (base de altitud) sale de `TTabla`, **no** de `TableP`, para heredar los nombres
  de estado ya normalizados. No se pierde ningún registro por el cambio: los 21,408 con
  altitud válida traen coordenadas.
- **Los 21,408 registros tienen altitud.** No hay ningún `NA`, así que el deslizador no
  necesita la guarda contra `NA` que sí lleva la app de frijol.
- La normalización de `Raza_primaria` **fusiona** "Nal-Tel de Altura" con
  "Nal-tel de Altura": por eso los datos crudos tienen 64 razas y `Mex3` tiene 63.
- El Estado de México va como **`"Estado de México"`** (así lo produce el `revalue` de
  `global.R:29`), no como `"México"`. La tabla `capitales_altitud` se trajo de la app de
  frijol y hubo que ajustar justo esa cadena.
- `capitales_altitud` guarda el `cvegeo` de cada capital (cabecera municipal,
  `CVE_LOC = 0001`, catálogo AGEEML del INEGI), así que cada altitud es rastreable hasta
  su renglón de origen. **Las altitudes siguen pendientes de verificar una por una.**
- La Ciudad de México no existe como localidad única en el catálogo del INEGI (está
  partida en 16 alcaldías). Se usa Cuauhtémoc, donde está el Zócalo: 2,230 m.

### Los datos de tamaño de mazorca (`RawData.csv`)

Salen de un archivo distinto al del resto de la app, y eso trae tres consecuencias.

**1. Escribe tres nombres de raza diferente.** Usa "nh" en vez de "ñ", omite acentos y
antepone "Complejo". Se normalizan en `global.R` justo después de leer el archivo; sin
eso no se pueden ligar con su complejo racial y saldrían en gris:

| En `RawData.csv` | En el resto de la app |
|---|---|
| `Complejo Serrano de Jalisco` | `Serrano de Jalisco` |
| `Palomero Toluquenho` | `Palomero Toluqueño` |
| `Mushito de Michoacan` | `Mushito de Michoacán` |

**2. Las cuentas de razas no cuadran con la base principal, y es correcto que no cuadren:**

| | |
|---|---|
| Razas en la base de maíces | 63 |
| — sin ningún dato de mazorca (Choapaneco, Harinoso de Ocho, Negro de Chimaltenango, Palomero de Jalisco, Quicheño) | −5 |
| + Mushito de Michoacán, que está en `RawData.csv` pero **no** en la base de maíces | +1 |
| Razas con dato de mazorca | 59 |
| — Uruapeño, con un solo registro (mínimo = máximo = 20 cm), sin rango que dibujar | −1 |
| **Dibujadas en la gráfica** | **58** |

Mushito de Michoacán es la única que sale en gris ("Sin complejo"), porque al no estar en
`TablaPP` no tiene complejo racial asignado. **Queda por decidir** si es una raza que
faltó en la base principal o un nombre alterno de "Mushito".

**3. Los mínimos que no eran creíbles — RESUELTO (7 de septiembre de 2026) con un piso
de 5 cm.**

La mazorca se dibuja de mínimo a máximo, así que un solo renglón mal capturado le definía
la forma a razas con más de mil colectas. Los valores imposibles eran exactamente tres:

| Raza | Longitud | Estado |
|---|---|---|
| Cónico Norteño | 1 cm | Chihuahua |
| Cónico Norteño | 2 cm | Zacatecas |
| Tuxpeño | 4 cm | Oaxaca |

`global.R` filtra ahora con `filter(Longitud >= 5, Longitud <= 50)`. Efecto: Cónico
Norteño pasa de 1 a **8.2 cm** y Tuxpeño de 4 a **6.4 cm**. Cuesta 3 registros de 10,358
(el 0.03%).

⚠️ **El corte va en 5 y no en 6 a propósito.** Hay dos registros de 6 cm — Nal-tel
(Yucatán) y Zapalote Chico (Oaxaca) — que **sí son creíbles**, porque son razas de mazorca
genuinamente corta. Un piso de 6 se los llevaría.

### Por qué NO se usaron percentiles

Fue la primera propuesta y se descartó al medirla. Los percentiles 5–95 habrían recortado
el mínimo más de 3 cm en **15 de las 59 razas**, y en la mayoría ese mínimo es correcto:
Olotillo 8.5 cm, Celaya 9.7, Tabloncillo 10.0. Habrían quitado mazorcas pequeñas legítimas
junto con los errores.

Además cambian lo que la figura **afirma**: de "mínimo y máximo registrados" a "rango
habitual". Tuxpeño pasaría de 6.4–28.4 cm a 12.6–20.5. El problema eran tres renglones mal
capturados, no la distribución.

---|---|---|
| Cónico Norteño | **1 cm** | 777 |
| Tuxpeño | **4 cm** | 1,598 |

Una mazorca de un centímetro no existe. La alternativa es dibujar el **percentil 5 al 95**
en vez del mínimo y el máximo absolutos: la figura pasaría a decir "rango habitual" en
lugar de "mínimo y máximo", que para describir a una raza con 1,598 colectas es más
honesto. **Sin decidir.**

---

## 11. Versiones con las que quedó funcionando

```
R version 4.5.1 (2025-06-13)
plataforma: x86_64-apple-darwin20

shiny                1.14.0      leaflet              2.2.3
shinydashboard       0.7.3       ggplot2              4.0.3
shinydashboardPlus   2.0.6       ggiraph              0.9.6
shinyjs              2.1.1       ggrepel              0.9.8
shinyWidgets         0.9.1       dplyr                1.2.1
datamods             1.5.3       tidyverse            2.0.0
plyr                 1.8.9       readxl               1.5.0
plotly               4.12.1      googleVis            0.7.3
igraph               2.3.3       vcd                  1.4.14
scales               1.4.0       tableHTML            2.1.3
knitr                1.51        markdown             2.0
httr                 1.4.8       ggthemes             6.0.0
RColorBrewer         1.1.3
```

Este repositorio **no usa `renv`**. Las instalaciones van con `install.packages()`.

Paquetes que hubo que instalar y que no estaban: `ggrepel`, `datamods`.

---

## 12. De dónde viene todo esto

Las correcciones de las pestañas de Distribución y Altitud se trajeron de
**`CONABIO/shiny-agro-phaseolus`** (la app de frijol), donde están documentadas paso a
paso en `skill_distribucion_correccion.md`. Ese documento es la referencia larga; éste
recoge sólo lo que aplica a maíz, más lo que se descubrió aquí y allá no pasaba —
principalmente el asunto del locale, que en frijol no se notaba porque sus nombres
científicos no llevan acentos.
