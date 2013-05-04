import 'dart:html';
import 'dart:collection';
import 'dart:async';

var pq = new ListQueue();
final String TRANSITION_STYLE =
  'height 0.7s ease-in-out, '
  'margin 0.7s ease-in-out, '
  'opacity 0.7s ease-out';

var listDiv = new DivElement();

void main() {
  fillPq();

  for (var p in pq) {
    listDiv.children.add(p);
    p.style.margin = '0px 0px 10px 0px';
    p.style.zIndex = '1';
    p.style.position = 'relative';

    var span = p.query('span.name');
    span.style
      ..fontWeight = 'bold'
      //..color = 'blue'
      ..cursor = 'pointer';
    span.onClick.listen((_) => setTop(p));
  }

  var h2 = new HeadingElement.h1();
  h2.innerHtml = 'The Header';
  h2.style.color = 'green';
  h2.style.backgroundColor = 'white';
  h2.style.zIndex = '5';
  h2.style.opacity = '.99';
  h2.style.position = 'relative';
  document.body.children.add(h2);

  listDiv.style.zIndex = '1';
  listDiv.style.opacity = '.99';
  document.body.children.add(listDiv);
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
  div.style.height = '${div.clientHeight}px';

  new Timer(new Duration(milliseconds: 2), () {
      div.style.transition = TRANSITION_STYLE;
      div.style.opacity = '0';
      div.style.marginTop = '-${div.clientHeight + 10}px';
      for (var p in pq) {
        p.style.opacity = '.99';
      }
    });

  new Timer(new Duration(milliseconds: 703), () {
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
  p2.query('span.name').onClick.listen((_) => setTop(p2));
  return p2;
}

void fillPq() {
  for (var i = 0; i < 2; i++){
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
