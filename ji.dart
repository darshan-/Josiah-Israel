import 'dart:html';
import 'dart:collection';
import 'dart:async';

var pq = new ListQueue();
final String TRANSITION_STYLE =
  'height 0.7s ease-in-out, '
  'margin 0.7s ease-in-out, '
  'opacity 0.7s ease-out';

void main() {
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
  for (var p in pq) {
    document.body.children.add(p);
    p.style.height = '${p.clientHeight}px';
    p.style.margin = '0px 0px 10px 0px';

    var span = p.query('span.name');
    span.style
      ..fontWeight = 'bold'
      //..color = 'blue'
      ..cursor = 'pointer';
    span.onClick.listen((_) => setTop(p));
  }

  // Initial application of styles shouldn't be transitioned,
  //  so set transition style after main() returns.
  new Timer(new Duration(milliseconds: 2), () {
      for (var p in pq) {
        p.style.transition = TRANSITION_STYLE;
      }      
    });
}

void setTop(newTop) {
  while (pq.first != newTop) removeFirst();
}

void removeFirst() {
  var p1 = pq.removeFirst();
  var p2 = new ParagraphElement();

  p2.innerHtml = p1.innerHtml;
  p2.style.height  = p1.style.height;//'0px';
  p2.style.opacity = '0';
  p2.style.margin  = p1.style.margin;//'0';
  p2.style.transition = TRANSITION_STYLE;
  p2.query('span.name').onClick.listen((_) => setTop(p2));

  pq.addLast(p2);
  document.body.children.add(p2);

  var oldHeight  = p1.style.height;
  var oldOpacity = p1.style.opacity;
  var oldMargin  = p1.style.margin;
  p1.style.height  = '0px';
  p1.style.opacity = '0';
  p1.style.margin  = '0';

  new Timer(new Duration(milliseconds: 2), () {
      //p2.style.height = oldHeight;
      p2.style.opacity = oldOpacity;
      //p2.style.margin = oldMargin;
    });
  
  new Timer(new Duration(milliseconds: 1000), () {
      p1.remove();
    });
}
