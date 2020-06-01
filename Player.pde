class Player
{
  int numCoins;
  int id;
  Queue<beanTypes> hand;

  public Player(int _id) {
    numCoins = 0;
    id = _id;
    hand = new LinkedList();
  }

  public void DrawHand(boolean revealed) {

    pushMatrix();
    translate(width / 2 - 80 - (hand.size() / 2 * 25), 600);

    // iterate through players and draw cards
    Iterator<beanTypes> iterator = hand.iterator();
    while (iterator.hasNext()) {
      beanTypes bean = iterator.next();

      rotate(PI / 2);
      if (!revealed) {
        image(coinImage, 0, 0);
      } else {
        image(beanImages.get(bean), 0, 0);
      }
      rotate(-PI / 2);


      translate(50, 0);
    }

    popMatrix();
  }
}
