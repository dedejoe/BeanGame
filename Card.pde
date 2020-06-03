class Card {

  public beanTypes beanType;
  public boolean selected;
  public int x;
  public int y;

  Card(beanTypes b) {
    beanType = b;
    selected = false;
  }

  Card(beanTypes b, int _x, int _y) {
    beanType = b;
    selected = false;
    x = _x;
    y = _y;
  }

  boolean MouseOver() {
    if (mouseX >= x && mouseX <= x + beanWidth && mouseY >= y && mouseY <= y + beanHeight)
      return true;
    else
      return false;
  }
}
