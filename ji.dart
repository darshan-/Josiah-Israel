/*  Copyright (C) 2009-2013 Darshan-Josiah Barber */

import 'dart:html';
import 'dart:collection';
import 'dart:async';

import 'song_info.dart';

var song_queue = new ListQueue();

final BLOCK_REMOVAL_TRANSITION_STYLE =  'margin  0.7s ease-in-out, '
                                        'opacity 0.7s ease-out';

final SONG_INSERTION_TRANSITION_STYLE = 'opacity 0.8s ease-in';
final PAGE_SCROLL_TRANSITION_STYLE =    'margin  0.4s ease-in-out';

var listDiv = query('#song-list');

void main() {
  fillSongQueue();

  for (var p in song_queue) {
    listDiv.children.add(p);
    p.query('.$SONG_NAME_SPAN_CLASS').onClick.listen((_) => setTop(p));
  }

  listDiv.style.height = '${listDiv.clientHeight + 30}px';
  listDiv.style.overflow = 'hidden';
}

void setTop(newTop) {
  if (song_queue.first == newTop) return;

  var removalDiv = new DivElement();

  while (song_queue.first != newTop) {
    var orig = song_queue.removeFirst();
    var copy = copySongDiv(orig);
    copy.query('.$SONG_NAME_SPAN_CLASS').onClick.listen((_) => setTop(copy));

    orig.remove();
    removalDiv.children.add(orig);

    copy.style.transition = SONG_INSERTION_TRANSITION_STYLE;
    copy.style.opacity = '0';
    listDiv.children.add(copy);
    song_queue.addLast(copy);
  }

  listDiv.children.insert(0, removalDiv);

  scrollToTop();

  new Timer(new Duration(milliseconds: 25), () {
      removalDiv.style.transition = BLOCK_REMOVAL_TRANSITION_STYLE;
      removalDiv.style.opacity = '0';
      removalDiv.style.marginTop = '-${removalDiv.clientHeight + 24}px'; // (24 = .song-info marginBottom)
      for (var p in song_queue) {
        p.style.opacity = '1';
      }
    });

  new Timer(new Duration(milliseconds: 800), () {
      removalDiv.remove();
    });
}

void fillSongQueue() {
  for (var song in songs) {
    var div = divFromSong(song);
    div.style.opacity = '1';
    song_queue.addLast(div);
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
