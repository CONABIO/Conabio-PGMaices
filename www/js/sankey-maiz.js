// Sankey de complejo racial -> raza -> estado, dibujado con D3.
//
// Sustituye a gvisSankey (googleVis), que cargaba Google Charts desde
// gstatic.com en tiempo de ejecucion: si esa peticion falla, la grafica no
// aparece. Aqui D3 va servido desde el propio www/, sin dependencias externas.
//
// El servidor manda los datos ya agregados con sendCustomMessage. El dibujo
// hace un data join por id, asi que al cambiar de estado los nodos y los
// listones se mueven a su nueva posicion en vez de redibujarse de golpe.
(function () {
  var contenedor = "#sankey_d3";
  var svg = null, gLinks = null, gNodos = null, sankey = null;
  var DUR = 750;

  function inicializar(ancho, alto) {
    svg = d3.select(contenedor).append("svg")
      .attr("width", ancho).attr("height", alto)
      .attr("viewBox", [0, 0, ancho, alto])
      .style("max-width", "100%").style("height", "auto");
    gLinks = svg.append("g").attr("fill", "none");
    gNodos = svg.append("g");
    // nodeId permite referirse a los nodos por su id de texto y no por indice,
    // que es lo que hace posible conservar la identidad entre actualizaciones.
    sankey = d3.sankey()
      .nodeId(function (d) { return d.id; })
      .nodeWidth(14)
      .nodePadding(9)
      .nodeSort(null)
      .extent([[1, 6], [ancho - 1, alto - 6]]);
  }

  function dibujar(datos) {
    var ancho = Math.max(700, d3.select(contenedor).node().clientWidth || 900);
    var alto = Array.isArray(datos.alto) ? datos.alto[0] : datos.alto;
    // Igual que en la mazorca: el SVG se crea una sola vez y despues solo se le
    // ajustan las medidas. Reinicializarlo al cambiar de alto borraba todo y lo
    // redibujaba de golpe, perdiendo la transicion.
    if (!svg) inicializar(ancho, alto);
    svg.attr("width", ancho).attr("height", alto)
       .attr("viewBox", [0, 0, ancho, alto]);
    sankey.extent([[1, 6], [ancho - 1, alto - 6]]);

    // sankey() muta los objetos que recibe, asi que se le pasa una copia.
    var g = sankey({
      nodes: datos.nodes.map(function (d) { return Object.assign({}, d); }),
      links: datos.links.map(function (d) { return Object.assign({}, d); })
    });

    var camino = d3.sankeyLinkHorizontal();

    // ---- listones ----
    var links = gLinks.selectAll("path")
      .data(g.links, function (d) { return d.source.id + "->" + d.target.id; });

    // Salida inmediata: ver el comentario equivalente en mazorca-maiz.js.
    links.exit().remove();

    links.enter().append("path")
        .attr("stroke", function (d) { return d.color; })
        .attr("stroke-opacity", 0)
        .attr("d", camino)
        .attr("stroke-width", function (d) { return Math.max(1, d.width); })
        .call(function (sel) { sel.append("title"); })
      .merge(links)
        .on("mouseover", function (e, d) {
          d3.select(this).attr("stroke-opacity", 0.75);
        })
        .on("mouseout", function (e, d) {
          d3.select(this).attr("stroke-opacity", 0.38);
        })
        .select("title")
          .text(function (d) {
            return d.source.nombre + " -> " + d.target.nombre + "\n" +
                   d.value.toLocaleString("es-MX") + " registros";
          });

    gLinks.selectAll("path").transition().duration(DUR)
      .attr("d", camino)
      .attr("stroke", function (d) { return d.color; })
      .attr("stroke-width", function (d) { return Math.max(1, d.width); })
      .attr("stroke-opacity", 0.38);

    // ---- nodos ----
    var nodos = gNodos.selectAll("g.nodo")
      .data(g.nodes, function (d) { return d.id; });

    nodos.exit().remove();

    var nuevos = nodos.enter().append("g").attr("class", "nodo").style("opacity", 0);
    nuevos.append("rect").attr("stroke", "#444").attr("stroke-width", 0.4);
    nuevos.append("text")
      .attr("font-size", 10)
      .attr("dominant-baseline", "middle")
      .attr("fill", "#222")
      .style("pointer-events", "none");
    nuevos.append("title");

    var todos = nuevos.merge(nodos);

    todos.select("title").text(function (d) {
      return d.nombre + "\n" + d.value.toLocaleString("es-MX") + " registros";
    });

    todos.transition().duration(DUR).style("opacity", 1);

    todos.select("rect").transition().duration(DUR)
      .attr("x", function (d) { return d.x0; })
      .attr("y", function (d) { return d.y0; })
      .attr("height", function (d) { return Math.max(1, d.y1 - d.y0); })
      .attr("width", function (d) { return d.x1 - d.x0; })
      .attr("fill", function (d) { return d.color; });

    todos.select("text").transition().duration(DUR)
      // las etiquetas del ultimo nivel se escriben a la izquierda del nodo
      // para que no se salgan del svg
      .attr("x", function (d) { return d.x0 < ancho / 2 ? d.x1 + 5 : d.x0 - 5; })
      .attr("y", function (d) { return (d.y1 + d.y0) / 2; })
      .attr("text-anchor", function (d) { return d.x0 < ancho / 2 ? "start" : "end"; })
      .text(function (d) { return (d.y1 - d.y0) > 7 ? d.nombre : ""; });
  }

  // Handshake: los mensajes que llegan antes de que exista el manejador se
  // pierden, asi que el cliente avisa al servidor cuando ya esta listo.
  Shiny.addCustomMessageHandler("sankeyMaiz", dibujar);
  $(document).on("shiny:connected", function () {
    Shiny.setInputValue("sankey_listo", Date.now());
  });
})();
