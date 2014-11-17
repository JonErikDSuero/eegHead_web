// define dimensions of graph
var m = [80, 80, 80, 80]; // margins
var w = 1250 - m[1] - m[3]; // width
var h = 500 - m[0] - m[2]; // height

// define graph and x-y axes
var graph = d3.select("#graph").append("svg:svg")
.attr("width", w + m[1] + m[3])
.attr("height", h + m[0] + m[2])
.append("svg:g")
.attr("transform", "translate(" + m[3] + "," + m[0] + ")");


function drawLineChart(data){
  var x = d3.time.scale().domain([new Date(data.date_min), new Date(data.date_max)]).range([0, w]);
  var y = d3.scale.linear().domain([data.value_min, data.value_max]).range([h, 0]);

  var line = d3.svg.line()
  .x(function(d) {
    return x( new Date(d[0]) ); // x-coordinate
  })
  .y(function(d) {
    return y(d[1]); // y-coordinate
  })

  var xAxis = d3.svg.axis().scale(x).orient("bottom").tickFormat(d3.time.format("%H:%M:%S"));
  var yAxis = d3.svg.axis().scale(y).ticks(4).orient("left");

  // Draw
  graph.append("svg:g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + h + ")");
  graph.selectAll("g .x.axis").call(xAxis);

  graph.append("svg:g")
  .attr("class", "y axis")
  .attr("transform", "translate(-25,0)");
  graph.selectAll("g .y.axis").call(yAxis);

  graph.append("svg:path").attr("d", line(data.points));
}

function updateLineChart(wave_type){
  $.post( "/v1/waves/graph_points", { wave_type: wave_type}, function( data ) {
    drawLineChart(data);
  }, "json");
}

updateLineChart("wave0");
//updateLineChart("wave1");
