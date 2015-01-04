// define dimensions of graph
var m = [100, 100, 100, 100]; // margins
var w = 1250 - m[1] - m[3]; // width
var h = 500 - m[0] - m[2]; // height
var graph = {}


// initialize line_charts
$('.aGraph').each( function(a_graph){
  var wave_type = $(this).attr("wave_type");
  graph[wave_type] = d3.select(".aGraph[wave_type='"+wave_type+"']").append("svg:svg")
  .attr("width", w + m[1] + m[3])
  .attr("height", h + m[0] + m[2])
  .append("svg:g")
  .attr("transform", "translate(" + m[3] + "," + m[0] + ")");
});

function updateLineChart(data, wave_type){
  //data.y_min = 0;
  //data.y_max = 10;
  //data.points = [[1,2], [3,5]];
  var x = d3.time.scale().domain([0, player.getDuration()]).range([0, w]);
  var y = d3.scale.linear().domain([data.y_min, data.y_max]).range([h, 0]);

  var line = d3.svg.line()
  .x(function(d) {
    return x( new Date(d[0]) ); // x-coordinate
  })
  .y(function(d) {
    return y(d[1]); // y-coordinate
  })

  //var xAxis = d3.svg.axis().scale(x).orient("bottom").tickFormat(d3.time.format("%H:%M:%S"));
  var xAxis = d3.svg.axis().scale(x).ticks(4).orient("bottom");
  var yAxis = d3.svg.axis().scale(y).ticks(4).orient("left");

  // Draw
  graph[wave_type].append("svg:g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + h + ")");
  graph[wave_type].selectAll("g .x.axis").call(xAxis);

  graph[wave_type].append("svg:g")
  .attr("class", "y axis")
  .attr("transform", "translate(-25,0)");
  graph[wave_type].selectAll("g .y.axis").call(yAxis);

  graph[wave_type].selectAll("path").remove();
  graph[wave_type].append("svg:path")
  .attr('d', line(data.points));
}

// Grab Updates for the Waves using Server Sent Events
//jQuery(document).ready(function() {
  //var source = new EventSource('/v1/waves/updates_stream');
  //source.addEventListener('updates_stream', function(e) {
    //var data = JSON.parse(e.data);
    //updateLineChart(data, data.wave_type)
  //});
//});


//Video Sessions Buttons
$('body').on('click', '.session', function() {
  console.log('CLICKED!!');
  params = {
    // the following values are from 'youtube_watch.js'
    video_id: video_id,
    video_session_code: $(this).data('sessionCode'),
  }
  $.post('/v1/video_sessions/graph_points', params, function(data){
    for (var wave_type in data){
      console.log('setting up..')
      updateLineChart(data[wave_type], wave_type)
    }
    $('#waves_graphs').show()
  });
});

