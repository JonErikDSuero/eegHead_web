// define dimensions of graph
var m = [50, 50, 50, 117]; // margins [top, right, bottom, left]
var w = 854; // width
var h = 480;// height
var graph = {}


// initialize line_charts
$('#graphsModal .aGraph').each( function(a_graph){
  var wave_type = $(this).attr("wave_type");
  graph[wave_type] = d3.select("#graphsModal .aGraph[wave_type='"+wave_type+"']").append("svg:svg")
  .attr("width", w + m[1] + m[3])
  .attr("height", h + m[0] + m[2])
  .append("svg:g")
  .attr("transform", "translate(" + m[3] + "," + m[0] + ")");
});

function updateLineChart(data, wave_type){
  var video_duration = Math.trunc(youtube_player.getDuration());

  if (data.y_min == data.y_max) { // fix if min and max are the same
    data.y_min = data.y_min-1;
    data.y_max = data.y_max+1;
  }

  data.points = data.points.filter(function(e) { //remove extra data.points
    return e[0]<=video_duration;
  });

  var x = d3.time.scale().domain([new Date(0, 0, 0, 0, 0, 0), new Date(0, 0, 0, 0, 0, video_duration)]).range([0, w]);
  var y = d3.scale.linear().domain([data.y_min, data.y_max]).range([h, 0]);

  var line = d3.svg.line()
  .x(function(d) {
    return x( new Date(0, 0, 0, 0, 0, d[0]) ); // x-coordinate
  })
  .y(function(d) {
    return y(d[1]); // y-coordinate
  })

  var xAxis = d3.svg.axis().scale(x).orient("bottom").tickFormat(d3.time.format("%M:%S"), 4);
  var yAxis = d3.svg.axis().scale(y).orient("left").ticks(4);

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

//Video Sessions Buttons
$('body').on('click', '.personal .session', function() {
  params = {
    video_session_code: $(this).data('sessionCode'),
  }
  $.post('/v1/video_sessions/graph_points', params, function(data){
    for (var wave_type in data){
      console.log(wave_type);
      console.log(data[wave_type]);
      updateLineChart(data[wave_type], wave_type)
    }
    $('#graphsModal #waves_graphs').show()
  });
});

$('body').on('click', '.session_delete', function(){
  console.log('deleting');
  params = {
    video_session_code: $(this).data('sessionCode'),
  }

  if (params["video_session_code"] == ""){
    location.reload();
  }

  $.post('/v1/video_sessions/delete_all', params, function(data){
    location.reload();
  });
});


$(window).on("blur focus", function(e) {
  var prevType = $(this).data("prevType");

  if (prevType != e.type) {   //  reduce double fire issues
    switch (e.type) {
      case "blur":
        //console.log("BLUR");
        //console.log(document.activeElement);
        if (document.activeElement.tagName == "BODY") {
          console.log(youtube_state);
          if (youtube_state == 'playing') {
            $('#resetModal').foundation('reveal', 'open');
          }
        }
      break;
    }
  }

  $(this).data("prevType", e.type);
})
