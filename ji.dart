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

  var removalDiv = new DivElement();

  while (song_queue.first != newTop) {
    var orig = song_queue.removeFirst();
    var copy = copyDiv(orig);

    orig.remove();
    removalDiv.children.add(orig);

    copy.style.transition = 'opacity 0.8s ease-in';
    copy.style.opacity = '0';
    listDiv.children.add(copy);
    song_queue.addLast(copy);
  }

  listDiv.children.insert(0, removalDiv);

  // Transitioned scrolling technique from:
  //   http://mitgux.com/smooth-scroll-to-top-using-css3-animations
  //
  // I'm happy with it other than the effect on the scroll bar (rather than
  //   actually scrolling the page, we're shrinking and then growing it, so
  //   the scrollbar grows and then shrinks rather than sliding), but it's
  //   good enough for now.

  document.body.style.transition = 'none';
  document.body.style.marginTop = '-${window.scrollY}px';
  window.scrollTo(window.scrollX, 0);

  new Timer(new Duration(milliseconds: 25), () {
      document.body.style.transition = 'margin 0.4s ease-in-out';
      document.body.style.marginTop = '0';

      removalDiv.style.transition = TRANSITION_STYLE;
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

copyDiv(d1) {
  var d2 = new DivElement();
  d2.innerHtml = d1.innerHtml;
  d2.classes.add('song-info');
  d2.style.opacity = d1.style.opacity;
  d2.query('span.songname').onClick.listen((_) => setTop(d2));
  return d2;
}

void fillSongQueue() {
  for (var song in songs) {
    var div = new DivElement();
    div.classes.add('song-info');
    div.style.opacity = '1';

    var desc = song['description'];
    if (! desc.contains('<p>'))
      desc = '<p>$desc</p>';

    var header =
      '<p><span class="songname">${song["name"]}</span>'
      ' - '
      '<i>${prettyDate(song["date"])}</i></p>\n';

    div.innerHtml = header + desc;

    song_queue.addLast(div);
  }
}

String prettyDate(s) {
  var months = {
    "01" : "January",
    "02" : "February",
    "03" : "March",
    "04" : "April",
    "05" : "May",
    "06" : "June",
    "07" : "July",
    "08" : "August",
    "09" : "September",
    "10" : "October",
    "11" : "November",
    "12" : "December"
  };

  var year = s.substring(0, 4);

  if (! s[4].contains(new RegExp(r'\d')))
    return s.substring(4) + " " + year;

  var month = months[s.substring(4, 6)];

  var ret = "";

  if (s.length > 6) {
    var day = s.substring(6, 8);

    if (day[0] == '0')
      day = day[1];

    if (day != null)
      ret += day + " ";
  }

  ret += month + " ";
  ret += year;

  return ret;
}
