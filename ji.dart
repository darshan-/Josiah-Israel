import 'dart:html';
import 'dart:collection';
import 'dart:async';

var pq = new ListQueue();

void main() {
  var p = new ParagraphElement();
  p.innerHtml = "The First Paragraph<br />Still the first paragraph.";
  pq.addLast(p);

  p = new ParagraphElement();
  p.innerHtml = "The Second Paragraph<br />Second still.<br />Second still.";
  pq.addLast(p);

  p = new ParagraphElement();
  p.innerHtml =
    "The Third Paragraph<br />"
    "The Third Paragraph<br />"
    "The Third Paragraph<br />"
    "The Third Paragraph<br />"
    "The Third Paragraph<br />"
    "The Third Paragraph<br />" ;
  pq.addLast(p);

  var b1 = new ButtonElement();
  b1.innerHtml = "Press me!";
  b1.onClick.listen(buttonPressed);

  document.body.children.add(b1);

  for (var p in pq) {
    document.body.children.add(p);
    p.style.height = '${p.clientHeight}px';
    p.style.margin = '10px 0px 10px 0px';
  }

  // Initial application of styles shouldn't be transitioned,
  //  so set transition style after main() returns.
  new Timer(new Duration(milliseconds: 50), () {
      for (var p in pq) {
        p.style.transition = 'all 1s';
      }      
    });
}

void buttonPressed(event) {
  var p1 = pq.removeFirst();
  var p2 = new ParagraphElement();

  p2.innerHtml = p1.innerHtml;
  p2.style.height  = '0px';
  p2.style.opacity = '0';
  p2.style.margin  = '0';
  p2.style.transition = 'all 1s';

  pq.addLast(p2);
  document.body.children.add(p2);

  var oldHeight  = p1.style.height;
  var oldOpacity = p1.style.opacity;
  var oldMargin  = p1.style.margin;
  p1.style.height  = '0px';
  p1.style.opacity = '0';
  p1.style.margin  = '0';

  new Timer(new Duration(milliseconds: 50), () {
      p2.style.height = oldHeight;
      p2.style.opacity = oldOpacity;
      p2.style.margin = oldMargin;
    });
  
  new Timer(new Duration(milliseconds: 1000), () {
      p1.remove();
    });
}
