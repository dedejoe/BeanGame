


class Player
{
  int numCoins;
  int id;
  LinkedList<Card> hand;
  int maxBeanFields;
  beanTypes[] beanFields;
  int[] beanFieldAmounts;
  int beanY() { 
    return height - (beanWidth / 3) - (beanHeight / 2 + (beanWidth * 5 / 8));
  }
  int beanX() { 
    return width / 2 - ((beanWidth / 2) * hand.size() / 2);
  }

  public Player(int _id) {
    numCoins = 0;
    id = _id;
    hand = new LinkedList();
    maxBeanFields = 2;
    beanFields = new beanTypes[maxBeanFields];
    beanFieldAmounts = new int[maxBeanFields];
    beanFields[0] = beanTypes.cocoa;
    beanFields[1] = beanTypes.cocoa;
    beanFieldAmounts[0] = 0;
    beanFieldAmounts[1] = 0;
  }

  public void RenderHand() {

    int counter = 0;
    pushMatrix();
    translate(beanX(), beanY());

    // iterate through players and draw cards
    Iterator<Card> iterator = hand.iterator();
    while (iterator.hasNext()) {
      Card card = iterator.next();

      if (card.selected == true) {
        translate(0, -25);
        image(beanImages.get(card.beanType), 0, 0);
        translate(0, 25);
      } else {
        image(beanImages.get(card.beanType), 0, 0);
      }

      translate((beanWidth / 3), 0);
      counter++;
    }

    popMatrix();
  }

  public void RenderBeanFields() {

    pushMatrix();
    translate(width / 4 * 3 + beanWidth / 3, height / 10);

    for (int i = 0; i < maxBeanFields; i++) {
      if (beanFieldAmounts[i] == 0) {
        continue;
      }

      translate(beanWidth / 1.9 * i, 0);

      pushMatrix();
      resetMatrix();
      harvestFieldButtons[i].Render();
      popMatrix();

      int counter = 0;

      while (counter < beanFieldAmounts[i]) {
        counter++;
        image(beanImages.get(beanFields[i]), 0, 0, beanWidth / 2, beanHeight / 2);
        translate(0, (beanWidth / 3));
      }

      translate(-beanWidth / 1.9 * i, -(beanWidth / 3) * counter);
    }
    popMatrix();
  }

  public int OverCard() {

    int x = beanX();
    int y = beanY();
    int index = -1;
    int counter = 0;

    Iterator<Card> iterator = hand.iterator();
    while (iterator.hasNext()) {
      Card card = iterator.next();

      if (mouseY >= y && mouseY <= y + beanHeight) {

        if (mouseX >= x && mouseX <= x + beanWidth) {

          index = counter;
        }
      }
      x += (beanWidth / 3);
      counter++;
    }

    return index;
  }

  public void DrawCards(int num) {

    for (int i = 0; i < num; i++) {
      hand.addFirst(new Card((beanTypes)deck.pop()));

      // shuffle
      if (deck.size() == 0) {
        while (discard.size() > 0) {
          deck.push(discard.pop());
        }
        Collections.shuffle(deck);
      }
    }
  }

  public void PlantBean(beanTypes bean, boolean fromHand) {
    int i = GetField(bean);
    beanFieldAmounts[i]++;
    if (fromHand)
      hand.removeLast();
    beanFields[i] = bean;
    
    UpdateBeanFields();
  }

  public void ProposeTrade() {
  }

  private int GetField(beanTypes bean) {
    int index = 0;
    if (PlantingBeanType(bean)) {
      for (int i = 0; i < maxBeanFields; i++) {
        if (beanFields[i] == bean) index = i;
      }
    } else {
      for (int i = 0; i < maxBeanFields; i++) {
        if (beanFieldAmounts[i] == 0) return i;
      }
    }
    return index;
  }

  public boolean CanPlantBean(beanTypes bean) {

    return (PlantingBeanType(bean) || HasEmptyField());
  }

  public boolean HasSelectedBeans() { 
    Iterator<Card> iterator = hand.iterator();
    while (iterator.hasNext()) {
      Card card = iterator.next();

      if (card.selected == true) {
        return true;
      }
    }

    return false;
  }

  public boolean PlantingBeanType(beanTypes bean) {

    for (int i = 0; i < maxBeanFields; i++) {
      if (beanFields[i] == bean && beanFieldAmounts[i] > 0)
        return true;
    }

    return false;
  }

  public boolean HasEmptyField() {
    for (int i = 0; i < maxBeanFields; i++) {
      if (beanFieldAmounts[i] == 0)
        return true;
    }
    return false;
  }

  public void HarvestField(int fieldNumber) {
    int[] values = beanValues.get(beanFields[fieldNumber]);

    for (int i = 3; i >= 0; i--) {
      if (values.length <= i) continue;
      if (beanFieldAmounts[fieldNumber] >= values[i]) {
        numCoins += (i + 1);
        for (int l = 0; l < beanFieldAmounts[fieldNumber]; l++) {
          discard.push(beanFields[fieldNumber]);
        }
        beanFieldAmounts[fieldNumber] = 0;
        UpdateBeanFields();
        return;
      }
    }
    UpdateBeanFields();
    beanFieldAmounts[fieldNumber] = 0;
  }
}
