/* implementation heavily influenced by http://bl.ocks.org/1166403 */

// define dimensions of graph
var m = [80, 80, 80, 80]; // margins
var w = 1250 - m[1] - m[3]; // width
var h = 500 - m[0] - m[2]; // height

$.post( "/v1/waves/graph_points", { wave_type: "wave0"}, function( data ) {

  //var data = [[1,3],[2,5],[3,1]];

  //debugger;
  var x = d3.time.scale().domain([new Date(data.date_min), new Date(data.date_max)]).range([0, w]);
  var y = d3.scale.linear().domain([data.value_min, data.value_max]).range([h, 0]);

  var line = d3.svg.line()
  .x(function(d) {
    var x_coord = x( new Date(d[0]) ); // x-coordinate
    return x_coord;
  })
  .y(function(d) {
    var y_coord = y(d[1]); //y-coordinate
    console.log("y_coord: "+y_coord+" => "+d[1]);
    return y_coord;
  })

  // Add an SVG element with the desired dimensions and margin.
  var graph = d3.select("#graph").append("svg:svg")
  .attr("width", w + m[1] + m[3])
  .attr("height", h + m[0] + m[2])
  .append("svg:g")
  .attr("transform", "translate(" + m[3] + "," + m[0] + ")");

  // create yAxis
  //var xAxis = d3.svg.axis().scale(x).tickSize(-h).tickSubdivide(true);
  var xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom")
  .tickFormat(d3.time.format("%H:%M:%S"));
  // Add the x-axis.
  graph.append("svg:g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + h + ")")
  .call(xAxis);


  // create left yAxis
  var yAxisLeft = d3.svg.axis().scale(y).ticks(4).orient("left");
  // Add the y-axis to the left
  graph.append("svg:g")
  .attr("class", "y axis")
  .attr("transform", "translate(-25,0)")
  .call(yAxisLeft);

  // Add the line by appending an svg:path element with the data line we created above
  // do this AFTER the axes above so that the line is above the tick-lines
  graph.append("svg:path").attr("d", line(data.points));

}, "json");

