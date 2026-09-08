// Tamano de mazorca por raza, dibujado con D3.
//
// Cada raza es un elote acostado que va de su longitud minima a su maxima.
// La gracia de hacerlo en D3 y no en ggiraph es la TRANSICION: al cambiar el
// criterio de orden o los estados, cada elote se desliza a su nuevo renglon y
// se estira a su nueva longitud, en vez de que la figura se redibuje de golpe.
//
// Para que el morfeo sea posible, todos los elotes tienen SIEMPRE el mismo
// numero de vertices (60 por lado) y el mismo numero de hileras de granos (12),
// sin importar su longitud: si el conteo cambiara, no habria como interpolar
// un contorno con el otro.
(function () {
  var contenedor = "#mazorca_d3";
  var M = { top: 14, right: 26, bottom: 34, left: 160 };
  var DUR = 800, N = 60, HILERAS = 12;
  var svg = null, gEjes = null, gRazas = null, tip = null;

  // Media anchura del elote a lo largo de su eje: base redondeada en el primer
  // 7%, lados rectos, punta conica en el 20% final. Identica a la version de
  // ggplot, para que las dos figuras se vean iguales.
  function anchoElote(t) {
    if (t < 0.07) return Math.sqrt(Math.max(0, 1 - Math.pow((0.07 - t) / 0.07, 2)));
    if (t > 0.80) return 1 - 0.92 * Math.pow((t - 0.80) / 0.20, 1.4);
    return 1;
  }

  function pathElote(d, x, yc, semi) {
    var pts = [], i, t, w;
    for (i = 0; i < N; i++) {
      t = i / (N - 1);
      w = anchoElote(t) * semi;
      pts.push([x(d.minimo + t * (d.maximo - d.minimo)), yc - w]);
    }
    for (i = N - 1; i >= 0; i--) {
      t = i / (N - 1);
      w = anchoElote(t) * semi;
      pts.push([x(d.minimo + t * (d.maximo - d.minimo)), yc + w]);
    }
    return "M" + pts.map(function (p) { return p[0].toFixed(2) + "," + p[1].toFixed(2); }).join("L") + "Z";
  }

  // Hileras de granos: 12 rayitas verticales dentro del elote, siempre 12.
  function pathGranos(d, x, yc, semi) {
    var partes = [], i, t, w, xx;
    for (i = 1; i <= HILERAS; i++) {
      t = i / (HILERAS + 1);
      w = anchoElote(t) * semi * 0.72;
      xx = x(d.minimo + t * (d.maximo - d.minimo)).toFixed(2);
      partes.push("M" + xx + "," + (yc - w).toFixed(2) + "L" + xx + "," + (yc + w).toFixed(2));
    }
    return partes.join("");
  }

  function inicializar(ancho, alto) {
    svg = d3.select(contenedor).append("svg")
      .attr("width", ancho).attr("height", alto)
      .attr("viewBox", [0, 0, ancho, alto])
      .style("max-width", "100%").style("height", "auto");
    gEjes = svg.append("g");
    gRazas = svg.append("g");
    if (!tip) {
      tip = d3.select("body").append("div")
        .style("position", "absolute").style("pointer-events", "none")
        .style("background", "#333").style("color", "#fff")
        .style("padding", "5px 7px").style("border-radius", "4px")
        .style("font-size", "12px").style("white-space", "pre")
        .style("opacity", 0).style("z-index", 9999);
    }
  }

  function dibujar(datos) {
    var razas = datos.razas;
    var alto = Array.isArray(datos.alto) ? datos.alto[0] : datos.alto;
    var maxCm = Array.isArray(datos.maxCm) ? datos.maxCm[0] : datos.maxCm;
    var ancho = Math.max(640, d3.select(contenedor).node().clientWidth || 900);

    // El SVG se crea UNA sola vez. Antes se reinicializaba cada vez que cambiaba
    // el alto, y como el alto crece con el numero de razas (max(560, n*17+60)),
    // a partir de ~29 razas cada cambio borraba el SVG y lo reconstruia: de ahi
    // el parpadeo. Ahora solo se le ajustan las medidas y los elementos
    // sobreviven, que es justo lo que permite que se animen.
    if (!svg) inicializar(ancho, alto);
    svg.attr("width", ancho).attr("height", alto)
       .attr("viewBox", [0, 0, ancho, alto]);

    var x = d3.scaleLinear().domain([0, maxCm]).range([M.left, ancho - M.right]);
    var paso = (alto - M.top - M.bottom) / Math.max(1, razas.length);
    var semi = Math.min(7, paso * 0.40);
    // pos 0 es el mas corto y va ABAJO: de menor a mayor hacia arriba
    var yDe = function (d) { return alto - M.bottom - (d.pos - 0.5) * paso; };

    // ---- eje de cm ----
    var eje = d3.axisBottom(x).ticks(7).tickFormat(function (v) { return v + " cm"; });
    var gx = gEjes.selectAll("g.ejeX").data([0]);
    gx.enter().append("g").attr("class", "ejeX")
      .merge(gx)
      .transition().duration(DUR)
      .attr("transform", "translate(0," + (alto - M.bottom) + ")")
      .call(eje);

    var lineas = gEjes.selectAll("line.guia").data(x.ticks(7));
    lineas.enter().append("line").attr("class", "guia")
        .attr("stroke", "#dcdcdc").attr("stroke-dasharray", "3,3")
      .merge(lineas)
      .transition().duration(DUR)
        .attr("x1", x).attr("x2", x)
        .attr("y1", M.top).attr("y2", alto - M.bottom);
    lineas.exit().remove();

    // ---- elotes ----
    var g = gRazas.selectAll("g.raza").data(razas, function (d) { return d.raza; });

    // Salida INMEDIATA, sin transicion. Un .remove() encadenado a una
    // transicion solo se ejecuta cuando esta termina, y mientras tanto el nodo
    // sigue en el DOM: si llega otra actualizacion dentro de esa ventana,
    // selectAll("g.raza") lo vuelve a capturar, le interrumpe la transicion y
    // cancela su remocion. Los nodos se acumulan invisibles y la grafica se
    // vacia. Con .remove() directo eso no puede pasar.
    g.exit().remove();

    var nuevos = g.enter().append("g").attr("class", "raza").style("opacity", 0);
    nuevos.append("path").attr("class", "elote")
      .attr("stroke", "#3f3f3f").attr("stroke-width", 0.4);
    nuevos.append("path").attr("class", "granos")
      .attr("stroke", "#ffffff").attr("stroke-opacity", 0.5)
      .attr("stroke-width", 0.7).attr("fill", "none");
    nuevos.append("circle").attr("class", "prom")
      .attr("r", 2).attr("fill", "#fff").attr("stroke", "#333").attr("stroke-width", 0.5);
    nuevos.append("text").attr("class", "nombre")
      .attr("font-size", 10).attr("text-anchor", "end")
      .attr("dominant-baseline", "middle").attr("fill", "#222");

    // Los elotes que ENTRAN se colocan ya en su posicion final y solo aparecen
    // con un fundido. Si se dejara que su atributo "d" transicionara desde
    // vacio, el contorno saltaria de golpe en vez de incorporarse.
    nuevos.select("path.elote")
      .attr("fill", function (d) { return d.color; })
      .attr("d", function (d) { return pathElote(d, x, yDe(d), semi); });
    nuevos.select("path.granos")
      .attr("d", function (d) { return pathGranos(d, x, yDe(d), semi); });
    nuevos.select("circle.prom")
      .attr("cx", function (d) { return x(d.prom); })
      .attr("cy", yDe);
    nuevos.select("text.nombre")
      .attr("x", M.left - 8)
      .attr("y", yDe)
      .text(function (d) { return d.raza; });

    var todos = nuevos.merge(g);

    todos
      .on("mousemove", function (e, d) {
        tip.style("opacity", 1)
           .html(d.raza + "\n" + d.complejo + "\n" +
                 "mínimo " + d.minimo.toFixed(1) + " cm\n" +
                 "promedio " + d.prom.toFixed(1) + " cm\n" +
                 "máximo " + d.maximo.toFixed(1) + " cm\n" +
                 d.n + " registros")
           .style("left", (e.pageX + 14) + "px")
           .style("top", (e.pageY - 10) + "px");
        gRazas.selectAll("g.raza").style("opacity", function (o) {
          return o.raza === d.raza ? 1 : 0.28;
        });
      })
      .on("mouseleave", function () {
        tip.style("opacity", 0);
        gRazas.selectAll("g.raza").style("opacity", 1);
      });

    todos.transition().duration(DUR).style("opacity", 1);

    todos.select("path.elote").transition().duration(DUR)
      .attr("fill", function (d) { return d.color; })
      .attr("d", function (d) { return pathElote(d, x, yDe(d), semi); });

    todos.select("path.granos").transition().duration(DUR)
      .attr("d", function (d) { return pathGranos(d, x, yDe(d), semi); });

    todos.select("circle.prom").transition().duration(DUR)
      .attr("cx", function (d) { return x(d.prom); })
      .attr("cy", yDe);

    todos.select("text.nombre").transition().duration(DUR)
      .attr("x", M.left - 8)
      .attr("y", yDe)
      .text(function (d) { return d.raza; });
  }

  Shiny.addCustomMessageHandler("mazorcaMaiz", dibujar);
  $(document).on("shiny:connected", function () {
    Shiny.setInputValue("mazorca_listo", Date.now());
  });
})();
