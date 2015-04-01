// define dimensions of graph
var m = [50, 50, 50, 117]; // margins [top, right, bottom, left]
var w = 854; // width
var h = 480;// height
var graphStudents = {}
var numGraphStudents = 0;

var graphAverage;

var dataAll = {};

// initialize line_charts
$('.aGraph.student').each( function(a_graph){
  var studentCode = $(this).attr("student_code");
  graphStudents[studentCode] = d3.select(".aGraph.student[student_code='"+studentCode+"']").append("svg:svg")
  .attr("width", w + m[1] + m[3])
  .attr("height", h + m[0] + m[2])
  .append("svg:g")
  .attr("transform", "translate(" + m[3] + "," + m[0] + ")");
  numGraphStudents++;
});


graphAverage = d3.select(".aGraph.average").append("svg:svg")
.attr("width", w + m[1] + m[3])
.attr("height", h + m[0] + m[2])
.append("svg:g")
.attr("transform", "translate(" + m[3] + "," + m[0] + ")");


function updateStudentLineChart(data, graphToUpdate){
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
  graphToUpdate.append("svg:g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + h + ")");
  graphToUpdate.selectAll("g .x.axis").call(xAxis);

  graphToUpdate.append("svg:g")
  .attr("class", "y axis")
  .attr("transform", "translate(-25,0)");
  graphToUpdate.selectAll("g .y.axis").call(yAxis);

  graphToUpdate.selectAll("path").remove();
  graphToUpdate.append("svg:path")
  .attr('d', line(data.points));
}

//Video Sessions Buttons
$('body').on('click', '.students .session', function() {

  dataAll.raw = {};
  var counter = 0;

  $('.aGraph.student').each( function(a_graph){
    var studentCode = $(this).attr("student_code");
    params = {
      video_session_code: studentCode
    }
    $.post('/v1/video_sessions/graph_points', params, function(data){
      addToDataAll(dataAll, data["attention"]);
      updateStudentLineChart(data["attention"], graphStudents[studentCode]);
      $('#studentsModal #waves_graphs').show()

      counter++;
      if (counter==numGraphStudents){
        averageDataAll();
        updateStudentLineChart(dataAll, graphAverage);
      }

    });
  });
});


function addToDataAll(dataAll, src){

  if (isNaN(dataAll.y_min) || (dataAll.y_min > src.y_min)){
    dataAll.y_min = src.y_min
  }

  if (isNaN(dataAll.y_max) || (dataAll.y_max < src.y_max)){
    dataAll.y_max = src.y_max
  }

  var srclen = src.points.length;
  for (var i = 0; i < srclen; i++) {
    if (dataAll.raw[src.points[i][0]] == undefined) {
      dataAll.raw[src.points[i][0]] = 0;
    }
    dataAll.raw[src.points[i][0]] += (src.points[i][1])/numGraphStudents;
  }

  1==1;
}

function averageDataAll(){
  dataAll.points = [];
  $.each( dataAll.raw, function(index, value){
    dataAll.points.push([parseInt(index), value]);
  });
}

