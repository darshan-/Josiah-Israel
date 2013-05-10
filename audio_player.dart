library audio_player;

import 'dart:html';
import 'dart:uri';

class AudioPlayer {
  var prevSongCallback;
  var nextSongCallback;

  final _FILE_HOST = "http://darshancomputing.s3.amazonaws.com/JosiahIsrael/";

  bool _audioSupported;
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

      _audioSupported = (oggSupport == "probably" ||
                        mp3Support == "probably" ||
                        oggSupport == "maybe" ||
                        mp3Support == "maybe");
    } catch (e) {
      _audioSupported = false;
    }
  }

  AudioPlayer() {
    _checkAudioSupport();

    _playerArea = query('#player-area');

    _oggSource.type = 'audio/ogg';
    _mp3Source.type = 'audio/mp3';
    _audioElem.children.add(_oggSource);
    _audioElem.children.add(_mp3Source);

    _prevButton
      ..src = 'previous.png'
      ..alt = 'previous'
      ..onClick.listen(_prevSong);

    var seekBack = new ImageElement()
      ..src = 'backward.png'
      ..title = 'Backward 10 seconds'
      ..alt = 'back'
      ..onClick.listen(_seekBackward);

    _playButton
      ..src = 'play-disabled.png'
      ..title = 'Not ready'
      ..alt = 'play/pause'
      ..onClick.listen(_togglePause);

    var seekForward = new ImageElement()
      ..src = 'forward.png'
      ..title = 'forward 10 seconds'
      ..alt = 'forward'
      ..onClick.listen(_seekForward);

    _nextButton
      ..src = 'next.png'
      ..alt = 'next'
      ..onClick.listen(_nextSong);

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

    _audioElem.onCanPlay.listen((_) => _updatePlayPauseButton());
    _audioElem.onEnded.listen(_songEnded);
    _audioElem.onDurationChange.listen(_displayDuration);
    _audioElem.onTimeUpdate.listen(_displayCurrentTime);
  }

  void setPrev(String name) {
    _prevButton.title = 'Previous: $name';
  }

  void setNext(String name) {
    _nextButton.title = 'Next: $name';
  }

  void setSong(String name, String basename) {
    var shouldPlay = !_paused;

    if (basename == null) basename = name;

    _oggSource.src = encodeUri(_FILE_HOST + basename + '.ogg');
    _mp3Source.src = encodeUri(_FILE_HOST + basename + '.mp3');
    _audioElem.load();

    _curNameDiv.innerHtml = name;
    _curTimeDiv.innerHtml = '<span id="curtime">0:00</span> / <span id="duration">0:00</span>';

    _updatePlayPauseButton(); //Might have been ready before listener was set

    if (shouldPlay) playCur();
  }

  void _songEnded(_) {
    _nextSong(_);
    playCur();
  }

  void _nextSong(_) {
    if (nextSongCallback != null) nextSongCallback();
  }

  void _prevSong(_) {
    if (prevSongCallback != null) prevSongCallback();
  }

  void _seekForward(_) {
    _audioElem.currentTime += 10;
  }

  void _seekBackward(_) {
    _audioElem.currentTime -= 10;
  }

  void _togglePause(_) {
    if (_paused)
      playCur();
    else
      _pauseCur();
  }

  get _paused => _audioElem.paused;

  void playCur() {
    _audioElem.play();
    _updatePlayPauseButton();
  }

  void _pauseCur() {
    _audioElem.pause();
    _updatePlayPauseButton();
  }

  void _updatePlayPauseButton() {
    if (! _paused) {
      _playButton.src = 'pause.png';
      _playButton.title = 'Pause';
    } else if (_playable) {
      _playButton.src = 'play.png';
      _playButton.title = 'Play';
    } else {
      _playButton.src = 'play-disabled.png';
      _playButton.title = 'Not ready';
    }
  }

  get _playable => _audioElem.readyState >= 3;

  String _prettyTime(var time) {
    var mins = (time / 60).floor().toString();
    if (mins[0] == '-') mins = '0'; // Negatives could happen?

    var secs = (time.floor() % 60).round().toString();
    if (secs.length == 1) secs = '0' + secs;

    return mins + ':' + secs;
  }

  void _displayDuration(_) {
    var dur = _audioElem.duration;
    if (dur != null)
      _curTimeDiv.query('#duration').innerHtml = _prettyTime(dur);
  }

  void _displayCurrentTime(_) {
    var cur = _audioElem.currentTime;
    if (cur != null)
      _curTimeDiv.query('#curtime').innerHtml = _prettyTime(cur);
  }
}
