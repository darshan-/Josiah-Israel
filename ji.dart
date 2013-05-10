/*  Copyright (C) 2009-2013 Darshan-Josiah Barber */

import 'dart:html';
import 'dart:collection';
import 'dart:async';

import 'song_info.dart';
import 'audio_player.dart';

final BLOCK_REMOVAL_TRANSITION_STYLE =  'margin  0.7s ease-in-out, '
                                        'opacity 0.7s ease-out';

final SONG_INSERTION_TRANSITION_STYLE = 'margin  0.7s ease-in-out, '
                                        'opacity 0.7s ease-in';

final PAGE_SCROLL_TRANSITION_STYLE =    'margin  0.4s ease-in-out';

var songQueue = new ListQueue();
var listDiv = query('#song-list');
var player;

void main() {
  fillSongQueue();

  for (var song in songQueue) {
    listDiv.children.add(song.div);
    song.div.query('.$SONG_NAME_SPAN_CLASS').onClick.listen((_) => playSong(song));
  }

  listDiv.style.height = '${listDiv.clientHeight + 30}px';
  listDiv.style.overflow = 'hidden';

  player = new AudioPlayer();
  player.prevSongCallback = prevSong;
  player.nextSongCallback = nextSong;
  player.setSong(songQueue.first.info['name'], songQueue.first.info['basename']);
}

void prevSong() {
  // TODO: Simplify / minimize code duplication with setTop?
  var song = songQueue.removeLast();
  var origDiv = song.div;
  song.div = copySongDiv(origDiv);
  song.div.query('.$SONG_NAME_SPAN_CLASS').onClick.listen((_) => playSong(song));

  song.div.style.opacity = '0';
  listDiv.children.insert(0, song.div);
  song.div.style.marginTop = '-${song.div.clientHeight + 24}px'; // (24 = .song-info marginBottom)
  songQueue.addFirst(song);

  new Timer(new Duration(milliseconds: 25), () {
      origDiv.style.transition = BLOCK_REMOVAL_TRANSITION_STYLE;
      origDiv.style.opacity = '0';

      song.div.style.transition = SONG_INSERTION_TRANSITION_STYLE;
      song.div.style.marginTop = '0px';
      song.div.style.opacity = '1';
    });

  new Timer(new Duration(milliseconds: 400), () {
      player.setSong(songQueue.first.info['name'], songQueue.first.info['basename']);
    });

  new Timer(new Duration(milliseconds: 800), () {
      origDiv.remove();
    });
}

void nextSong() {
  var nextIndex = songQueue.length > 1 ? 1 : 0;
  setTop(songQueue.elementAt(nextIndex));
}

void playSong(song) {
  setTop(song);
  player.playCur();
}

void setTop(newTop) {
  if (songQueue.first == newTop) return;

  var removalDiv = new DivElement();

  while (songQueue.first != newTop) {
    var song = songQueue.removeFirst();
    var origDiv = song.div;
    song.div = copySongDiv(origDiv);
    song.div.query('.$SONG_NAME_SPAN_CLASS').onClick.listen((_) => playSong(song));

    origDiv.remove();
    removalDiv.children.add(origDiv);

    song.div.style.transition = SONG_INSERTION_TRANSITION_STYLE;
    song.div.style.opacity = '0';
    listDiv.children.add(song.div);
    songQueue.addLast(song);
  }

  // You'd think instant feedback would be better, but it actually seems nicer to
  //  wait for the slide effect to finish, or at least make it half way.
  //player.setSong(songQueue.first.info['name'], songQueue.first.info['basename']);

  listDiv.children.insert(0, removalDiv);

  scrollToTop();

  new Timer(new Duration(milliseconds: 25), () {
      removalDiv.style.transition = BLOCK_REMOVAL_TRANSITION_STYLE;
      removalDiv.style.opacity = '0';
      removalDiv.style.marginTop = '-${removalDiv.clientHeight + 24}px'; // (24 = .song-info marginBottom)
      for (var song in songQueue) {
        song.div.style.opacity = '1';
      }
    });

  new Timer(new Duration(milliseconds: 400), () {
      player.setSong(songQueue.first.info['name'], songQueue.first.info['basename']);
    });

  new Timer(new Duration(milliseconds: 800), () {
      //player.setSong(songQueue.first.info['name'], songQueue.first.info['basename']);
      removalDiv.remove();
    });
}

void fillSongQueue() {
  for (var info in SONG_INFOS) {
    songQueue.addLast(new Song(info));
  }
}

/*
  Transitioned scrolling technique from:
    http://mitgux.com/smooth-scroll-to-top-using-css3-animations

  I'm happy with it other than the effect on the scroll bar (rather than
    actually scrolling the page, we're shrinking and then growing it, so
    the scrollbar grows and then shrinks rather than sliding), but it's
    good enough for now.
*/
void scrollToTop() {
  document.body.style.marginTop = '-${window.scrollY}px';
  window.scrollTo(window.scrollX, 0);
  document.body.style.transition = 'none';

  new Timer(new Duration(milliseconds: 25), () {
      document.body.style.marginTop = '0';
      document.body.style.transition = PAGE_SCROLL_TRANSITION_STYLE;
    });
}
