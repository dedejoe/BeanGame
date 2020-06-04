class Button {

  int x;
  int y;
  int w;
  int h;
  String text;
  int index = 0;
  boolean clickable;

  Button(int _x, int _y, int _w, int _h, String t, int ind) {
    clickable = true;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = t;
    index = ind;
  };

  void Render() {

    if (MouseOver() && mousePressed || !clickable) {
      image(buttonDownImage, x, y, w, h);
      fill(#444444);
    } else {
      image(buttonImage, x, y, w, h);
      fill(#ffffff);
    }

    textSize((int)((float)w / 4.5));
    text(text, x + w / 2, y + h / 2 - h / 12);
  }

  void Clicked() {
    if (text == "Next") {
      if (phase == 2) {
        player().DrawCards(3);      
        incrementPhase();
      } else incrementPhase();
    } else if (text == "Harvest") {
      player().HarvestField(index);
    }
  }

  boolean MouseOver() {
    if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h)
      return true;
    else
      return false;
  }
}
