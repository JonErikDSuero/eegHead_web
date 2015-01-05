var youtube_player;
var video_id = $('#player').data('videoId');
var video_code = $('#player').data('videoCode');
var video_session_code = $('#player').data('videoSessionCode');
var replays = $('#sessions_list li').length;
var created_new_session = false;

function onYouTubePlayerAPIReady() {
  youtube_player = new YT.Player('player', {
    height: '480',
    width: '854',
    playerVars: {
      autoplay: 1,
      iv_load_policy: 3,
      rel: 0,
    },
    videoId: video_code,
    events: {
      'onStateChange': onPlayerStateChange
    }
  });
}

function onPlayerStateChange(event) {
  var states = {
    '-1': 'unstarted',
    '0': 'ended',
    '1': 'playing',
    '2': 'paused',
  }

  if (replays == 1) { return; } // Max number of recorded sessions

  params = {
    video_session_state: states[event.data],
    video_id: video_id,
    video_session_code: video_session_code,
    replays: replays,
  }

  if (params['video_session_state'] == 'paused') {
    createNewSession(video_session_code.toString() + ("0" + replays).slice(-2));
  } else if (params['video_session_state'] == 'ended') {
    replays++;
  }

  $.post( "/v1/video_sessions/insert", params, function(data) {
    console.log("Video Session Inserted: " + data.video_session.code);
  });
}

function createNewSession(code){
  if (created_new_session) { return; }
  buttons_html =  "<li>"
  buttons_html +=   "<a class='tiny button session' data-reveal-id='graphsModal' data-session-code="+code+"> Current </a>"
  buttons_html +=   "<a class='tiny secondary button session_delete' data-session-code="+code+"> x </a>"
  buttons_html += "</li>"
  $("ul#sessions_list").append(buttons_html);
  created_new_session = true;
}

onYouTubePlayerAPIReady();

