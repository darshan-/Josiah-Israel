library audio_player;

import 'dart:html';

class AudioPlayer {
  bool audioSupported;

  final _FILE_HOST = "http://darshancomputing.s3.amazonaws.com/JosiahIsrael/";

  var _playerArea;
  var _curNameDiv = new DivElement();
  var _curTimeDiv = new DivElement();
  var _controlsDiv = new DivElement();

  var _audioElem = new AudioElement();
  var _oggSource = new SourceElement();
  var _mp3Source = new SourceElement();

  var _songs;
  var _curIndex;

  boolean _checkAudioSupport() {
    var audio = new AudioElement();

    try {
      var oggSupport = audio.canPlayType('audio/ogg', '');
      var mp3Support = audio.canPlayType('audio/mpeg', '');

      audioSupported = (oggSupport == "probably" ||
                        mp3Support == "probably" ||
                        oggSupport == "maybe" ||
                        mp3Support == "maybe");
    } catch (e) {
      audioSupported = false;
    }
  }

  AudioPlayer(List<String> songNames) {
    _checkAudioSupport();

    _songs = songNames;

    _playerArea = query('#player-area');

    _oggSource.type = 'audio/ogg';
    _mp3Source.type = 'audio/mp3';
    _audioElem.children.add(_oggSource);
    _audioElem.children.add(_mp3Source);

    _playerArea.children
      ..clear()
      ..add(_curNameDiv)
      ..add(_curTimeDiv)
      ..add(_audioElem)
      ..add(_controlsDiv);

    setSong(0);
  }

  void setSong(int index) {
    if (index >= _songs.length) index = 0;
    if (index < 0) index = _songs.length - 1;

    _curIndex = index;

    var prevIndex = index - 1;
    if (prevIndex < 0) prevIndex = _songs.length - 1;

    var nextIndex = index + 1;
    if (nextIndex >= _songs.length) nextIndex = 0;

    var name = _songs[index]['name'];
    var basename = _songs[index]['basename'];
    if (basename == null) basename = name;
    var prevName = _songs[prevIndex]['name'];
    var nextName = _songs[nextIndex]['name'];

    _oggSource.src = _FILE_HOST + basename + '.ogg';
    _mp3Source.src = _FILE_HOST + basename + '.mp3';
    _audioElem.load();

    _curNameDiv.innerHtml = name;
    _curTimeDiv.innerHtml = '<span id="curtime">0:00</span> / <span id="duration">0:00</span>';

    _controlsDiv.innerHtml = '''
    <img title="Previous: $prevName " onClick="prevSong()" src="previous.png" />\
    <img title="Backward 10 seconds" onClick="seekBackward()" src="backward.png" />\
    <img title="Play" onClick="togglePause()" src="play-disabled.png" id="playpause_b" />\
    <img title="Forward 10 seconds" onClick="seekForward()" src="forward.png" />\
    <img title="Next: $nextName " onClick="nextSong()" src="next.png" />
''';

    /*
    au.addEventListener("ended", nextAndPlay, true);
    au.addEventListener("durationchange", dispDuration, true);
    au.addEventListener("timeupdate", dispCurrentTime, true);
    au.addEventListener("canplay", updatePlayPauseButton, true);

    updatePlayPauseButton(); //Might have been ready before listener was set
    */
  }

  /*
  function nextAndPlay() {
    setSong(_curIndex + 1);
    playCur();
  }

  function nextSong() {
    var shouldPlay = ! isPaused();
    setSong(_curIndex + 1);
    if (shouldPlay) playCur();
  }

  function prevSong() {
    var shouldPlay = ! isPaused();
    setSong(_curIndex - 1);
    if (shouldPlay) playCur();
  }

  function pauseCur() {
    document.getElementsByTagName("audio")[0].pause();
    updatePlayPauseButton();
  }

  function playCur() {
    document.getElementsByTagName("audio")[0].play();
    updatePlayPauseButton();
  }

  function seekForward() {
    document.getElementsByTagName("audio")[0].currentTime += 10;
  }

  function seekBackward() {
    document.getElementsByTagName("audio")[0].currentTime -= 10;
  }

  function updatePlayPauseButton() {
    var src;
    var title = "Play";

    if (! isPaused()) {
      src = "pause.png";
      title = "Pause";
    }
    else if (isPlayable()) src = "play.png";
    else src = "play-disabled.png";

    document.getElementById("playpause_b").src = src;
    document.getElementById("playpause_b").title = title;
  }

  function togglePause() {
    isPaused() ? playCur() : pauseCur();
  }

  function isPaused() {
    return document.getElementsByTagName("audio")[0].paused;
  }

  function isPlayable() {
    return (document.getElementsByTagName("audio")[0].readyState >= 3);
  }

  function getDuration() {
    return document.getElementsByTagName("audio")[0].duration;
  }

  function getCurrentTime() {
    return document.getElementsByTagName("audio")[0].currentTime;
  }

  function dispDuration() {
    var d = getDuration();
    if (d) document.getElementById("duration").innerHTML = prettyTime(d);
  }

  function dispCurrentTime() {
    var c = getCurrentTime();
    if (c) document.getElementById("curtime").innerHTML = prettyTime(c);
  }

  function prettyTime(t) {
    var m = Math.floor(t / 60);
    if (m < 0) m = "0";

    var s = Math.round(Math.floor(t) % 60).toString();
    if (s.length == 1) s = "0" + s;

    return m + ":" + s;
  }
  */
}
