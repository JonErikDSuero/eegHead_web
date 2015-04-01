// define dimensions of graph
var m = [50, 50, 50, 117]; // margins [top, right, bottom, left]
var w = 854; // width
var h = 480;// height
var graphStudents = {}

// initialize line_charts
$('#studentsModal .aGraph').each( function(a_graph){
  var studentCode = $(this).attr("student_code");
  graphStudents[studentCode] = d3.select("#studentsModal .aGraph[student_code='"+studentCode+"']").append("svg:svg")
  .attr("width", w + m[1] + m[3])
  .attr("height", h + m[0] + m[2])
  .append("svg:g")
  .attr("transform", "translate(" + m[3] + "," + m[0] + ")");
});

function updateStudentLineChart(data, studentCode){
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
  graphStudents[studentCode].append("svg:g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + h + ")");
  graphStudents[studentCode].selectAll("g .x.axis").call(xAxis);

  graphStudents[studentCode].append("svg:g")
  .attr("class", "y axis")
  .attr("transform", "translate(-25,0)");
  graphStudents[studentCode].selectAll("g .y.axis").call(yAxis);

  graphStudents[studentCode].selectAll("path").remove();
  graphStudents[studentCode].append("svg:path")
  .attr('d', line(data.points));
}

//Video Sessions Buttons
$('body').on('click', '.students .session', function() {
  $('#studentsModal .aGraph').each( function(a_graph){
    var studentCode = $(this).attr("student_code");
    params = {
      video_session_code: studentCode
    }
    $.post('/v1/video_sessions/graph_points', params, function(data){
      updateStudentLineChart(data["attention"], studentCode);
      $('#studentsModal #waves_graphs').show()
    });
  });
});

