import 'dart:html';
import 'dart:collection';
import 'dart:async';

var pq = new ListQueue();
final String TRANSITION_STYLE =
  'height 0.7s ease-in-out, '
  'margin 0.7s ease-in-out, '
  'opacity 0.7s ease-out';

var listDiv = query('#song-list');

void main() {
  fillPq();

  for (var p in pq) {
    listDiv.children.add(p);
    p.style.margin = '0px 0px 10px 0px';
    //p.style.zIndex = '1';
    //p.style.position = 'relative';

    var span = p.query('span.songname');
    //span.style
    //..fontWeight = 'bold'
      //..color = 'blue'
      //..cursor = 'pointer';
    span.onClick.listen((_) => setTop(p));
  }

  listDiv.style.height = '${listDiv.clientHeight}px';
  listDiv.style.overflow = 'hidden';
}

void setTop(newTop) {
  if (pq.first == newTop) return;

  var div = new DivElement();
  div.style.margin = '0px 0px 10px 0px';
  div.style.padding = '0';

  while (pq.first != newTop) {
    var p = pq.removeFirst();
    p.remove();
    div.children.add(p);
    var p2 = copyParagraph(p);
    listDiv.children.add(p2);
    pq.addLast(p2);
  }

  listDiv.children.insert(0, div);

  new Timer(new Duration(milliseconds: 25), () {
      div.style.transition = TRANSITION_STYLE;
      div.style.opacity = '0';
      div.style.marginTop = '-${div.clientHeight + 10}px';
      for (var p in pq) {
        p.style.opacity = '1';
      }
    });

  new Timer(new Duration(milliseconds: 727), () {
      div.remove();
    });
}

copyParagraph(p1) {
  var p2 = new ParagraphElement();
  p2.innerHtml = p1.innerHtml;
  p2.style.margin = p1.style.margin;
  p2.style.zIndex = p1.style.zIndex;
  p2.style.opacity = '0';
  p2.style.position = 'relative';
  p2.style.transition = 'opacity 0.7s ease-in';
  p2.query('span.songname').onClick.listen((_) => setTop(p2));
  return p2;
}

void fillPq() {
  for (var i = 0; i < 2; i++){
    var p = new ParagraphElement();
    p.innerHtml = '<span class="songname">Number 1</span> The First Paragraph<br />Still the first paragraph.';
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml = '<span class="songname">Number 2</span> The Second Paragraph<br />Second still.<br />Second still.';
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml =
      '<span class="songname">Number 3</span> '
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />" ;
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml = '<span class="songname">Number 4</span> The Fourth Paragraph<br />4th still.<br />fourth still.';
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml =
      '<span class="songname">Number 5</span> '
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />" ;
    pq.addLast(p);
  }
}
