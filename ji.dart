import 'dart:html';
import 'dart:collection';
import 'dart:async';

var pq = new ListQueue();
final String TRANSITION_STYLE =
  'height 0.7s ease-in-out, '
  'margin 0.7s ease-in-out, '
  'opacity 0.7s ease-out';

void main() {
  fillPq();

  for (var p in pq) {
    document.body.children.add(p);
    p.style.margin = '0px 0px 10px 0px';

    var span = p.query('span.name');
    span.style
      ..fontWeight = 'bold'
      //..color = 'blue'
      ..cursor = 'pointer';
    span.onClick.listen((_) => setTop(p));
  }
}

void setTop(newTop) {
  var div = new DivElement();
  div.style.margin = '0';
  div.style.padding = '0';

  while (pq.first != newTop) {
    var p = pq.removeFirst();
    p.remove();
    div.children.add(p);
    var p2 = copyParagraph(p);
    document.body.children.add(p2);
    pq.addLast(p2);
  }

  document.body.children.insert(0, div);
  div.style.height = '${div.clientHeight}px';

  new Timer(new Duration(milliseconds: 2), () {
      div.style.transition = TRANSITION_STYLE;
      div.style.opacity = '0';
      div.style.height = '0px';
    });

  new Timer(new Duration(milliseconds: 703), () {
      div.remove();
    });
}

copyParagraph(p1) {
  var p2 = new ParagraphElement();
  p2.innerHtml = p1.innerHtml;
  p2.style.margin = p1.style.margin;
  p2.query('span.name').onClick.listen((_) => setTop(p2));
  return p2;
}

void fillPq() {
  for (var i = 0; i < 3; i++){
    var p = new ParagraphElement();
    p.innerHtml = '<span class="name">Number 1</span> The First Paragraph<br />Still the first paragraph.';
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml = '<span class="name">Number 2</span> The Second Paragraph<br />Second still.<br />Second still.';
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml =
      '<span class="name">Number 3</span> '
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />"
      "The Third Paragraph<br />" ;
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml = '<span class="name">Number 4</span> The Fourth Paragraph<br />4th still.<br />fourth still.';
    pq.addLast(p);

    p = new ParagraphElement();
    p.innerHtml =
      '<span class="name">Number 5</span> '
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />"
      "The fifth Paragraph<br />" ;
    pq.addLast(p);
  }
}
