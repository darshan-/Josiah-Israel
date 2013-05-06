/*  Copyright (C) 2009-2013 Darshan-Josiah Barber */

import 'dart:html';
import 'dart:collection';
import 'dart:async';

import 'song_info.dart';

var song_queue = new ListQueue();

final String TRANSITION_STYLE =
  'height 0.7s ease-in-out, '
  'margin 0.7s ease-in-out, '
  'opacity 0.7s ease-out';

var listDiv = query('#song-list');

void main() {
  fillSongQueue();

  for (var p in song_queue) {
    listDiv.children.add(p);
    p.query('span.songname').onClick.listen((_) => setTop(p));
  }

  listDiv.style.height = '${listDiv.clientHeight + 30}px';
  listDiv.style.overflow = 'hidden';
}

void setTop(newTop) {
  if (song_queue.first == newTop) return;

  var div = new DivElement();

  while (song_queue.first != newTop) {
    var p = song_queue.removeFirst();
    p.remove();
    div.children.add(p);
    var p2 = copyDiv(p);
    listDiv.children.add(p2);
    song_queue.addLast(p2);
  }

  listDiv.children.insert(0, div);

  // TODO: Use window.pageYOffset (or window.scrollY?) to figure out how much scrolling
  //   is needed, combined with window.By(x, y) and requestAnimationFrame to do this
  //   gradually and smoothly?
  window.scrollTo(0, 0);

  new Timer(new Duration(milliseconds: 25), () {
      div.style.transition = TRANSITION_STYLE;
      div.style.opacity = '0';
      div.style.marginTop = '-${div.clientHeight + 15}px';
      for (var p in song_queue) {
        p.style.opacity = '1';
      }
    });

  new Timer(new Duration(milliseconds: 800), () {
      div.remove();
    });
}

copyDiv(d1) {
  var d2 = new DivElement();
  d2.innerHtml = d1.innerHtml;
  d2.style.opacity = '0';
  d2.style.position = 'relative';
  d2.style.transition = 'opacity 0.7s ease-in';
  d2.query('span.songname').onClick.listen((_) => setTop(d2));
  return d2;
}

void fillSongQueue() {
  for (var song in songs) {
    var div = new DivElement();

    var desc = song['description'];
    if (! desc.contains('<p>'))
      desc = '<p>$desc</p>';

    var header =
      '<p><span class="songname">${song["name"]}</span>'
      ' - '
      '<i>${song["date"]}</i></p>\n';

    div.innerHtml = header + desc;

    song_queue.addLast(div);
  }
}
