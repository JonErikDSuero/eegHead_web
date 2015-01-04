var player;
var video_id = $('#player').data('videoId');
var video_code = $('#player').data('videoCode');
var video_session_code = $('#player').data('videoSessionCode');
var replays = 0;

function onYouTubePlayerAPIReady() {
  player = new YT.Player('player', {
    height: '480',
    width: '854',
    videoId: video_code,
    events: {
      'onStateChange': onPlayerStateChange
    }
  });
}

function onPlayerStateChange(event) {
  states = {
    '-1': 'unstarted',
    '0': 'ended',
    '1': 'playing',
    '2': 'paused',
  }

  params = {
    video_session_state: states[event.data],
    video_id: video_id,
    video_session_code: video_session_code,
    replays: replays,
  }

  if (params['video_session_state'] == 'ended') {
    replays++;
  }

  $.post( "/v1/video_sessions/insert", params, function(data) {
    console.log("Data Loaded: " + data);
  });
}

onYouTubePlayerAPIReady();
