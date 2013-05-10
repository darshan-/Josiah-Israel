library audio_player;

import 'dart:html';
import 'dart:uri';

class AudioPlayer {
  bool audioSupported;

  final _FILE_HOST = "http://darshancomputing.s3.amazonaws.com/JosiahIsrael/";

  var _playerArea;

  var _curNameDiv = new DivElement()..id = 'curTrackName';
  var _curTimeDiv = new DivElement()..id = 'curTrackTime';
  var _controlsDiv = new DivElement()..id = 'controls';
  var _prevButton = new ImageElement();
  var _playButton = new ImageElement();
  var _nextButton = new ImageElement();

  var _audioElem = new AudioElement();
  var _oggSource = new SourceElement();
  var _mp3Source = new SourceElement();

  bool _checkAudioSupport() {
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

  AudioPlayer(void prevCallback(_), void nextCallback(_)) {
    _checkAudioSupport();

    _playerArea = query('#player-area');

    _oggSource.type = 'audio/ogg';
    _mp3Source.type = 'audio/mp3';
    _audioElem.children.add(_oggSource);
    _audioElem.children.add(_mp3Source);

    _prevButton
      ..src = 'previous.png'
      ..alt = 'previous'
      ..onClick.listen(prevCallback);

    var seekBack = new ImageElement()
      ..src = 'backward.png'
      ..title = 'Backward 10 seconds'
      ..alt = 'back'
      ..onClick.listen(seekBackward);

    _playButton
      ..src = 'play-disabled.png'
      ..title = 'Song not ready'
      ..alt = 'play'
      ..onClick.listen(togglePause);

    var seekForward = new ImageElement()
      ..src = 'forward.png'
      ..title = 'forward 10 seconds'
      ..alt = 'forward'
      ..onClick.listen(seekForward);

    _nextButton
      ..src = 'next.png'
      ..alt = 'next'
      ..onClick.listen(nextCallback);

    _controlsDiv.children
      ..add(_prevButton)
      ..add(seekBack)
      ..add(_playButton)
      ..add(seekForward)
      ..add(_nextButton);

    _playerArea.children
      ..clear()
      ..add(_curNameDiv)
      ..add(_curTimeDiv)
      ..add(_audioElem)
      ..add(_controlsDiv);
  }

  void setPrev(String name) {
    _prevButton.title = 'Previous: $name';
  }

  void setNext(String name) {
    _nextButton.title = 'Next: $name';
  }

  void setSong(String name, String basename) {
    if (basename == null) basename = name;

    _oggSource.src = encodeUri(_FILE_HOST + basename + '.ogg');
    _mp3Source.src = encodeUri(_FILE_HOST + basename + '.mp3');
    _audioElem.load();

    _curNameDiv.innerHtml = name;
    _curTimeDiv.innerHtml = '<span id="curtime">0:00</span> / <span id="duration">0:00</span>';

    /*
    au.addEventListener("ended", nextAndPlay, true);
    au.addEventListener("durationchange", dispDuration, true);
    au.addEventListener("timeupdate", dispCurrentTime, true);
    au.addEventListener("canplay", updatePlayPauseButton, true);

    updatePlayPauseButton(); //Might have been ready before listener was set
    */
  }

  void seekForward(_) {
    _audioElem.currentTime += 10;
  }

  void seekBackward(_) {
    _audioElem.currentTime -= 10;
  }

  void togglePause(_) {
    if (paused)
      playCur();
    else
      pauseCur();
  }

  get paused => _audioElem.paused;

  void playCur() {
    _audioElem.play();
    //updatePlayPauseButton();
  }

  void pauseCur() {
    _audioElem.pause();
    //updatePlayPauseButton();
  }

  /*
  function nextAndPlay() {
    setSong(_curIndex + 1);
    playCur();
  }

  function nextSong() {
    var shouldPlay = ! paused;
    setSong(_curIndex + 1);
    if (shouldPlay) playCur();
  }

  function prevSong() {
    var shouldPlay = ! paused;
    setSong(_curIndex - 1);
    if (shouldPlay) playCur();
  }

  function updatePlayPauseButton() {
    var src;
    var title = "Play";

    if (! paused) {
      src = "pause.png";
      title = "Pause";
    }
    else if (isPlayable()) src = "play.png";
    else src = "play-disabled.png";

    document.getElementById("playpause_b").src = src;
    document.getElementById("playpause_b").title = title;
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
