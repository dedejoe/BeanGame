void mousePressed () {
  int num = MouseOverEnemyBeans();
  
  if (num != -1) {
    enemyBeanCards[num].selected = !enemyBeanCards[num].selected;
  }
  
  int counter = 0;
  Iterator<Card> iterator = player().hand.iterator();
  while (iterator.hasNext()) {
    Card card;
    try {
      card = iterator.next();
    } 
    catch (ConcurrentModificationException e) {
      return;
    }

    if (counter == player().OverCard()) {
      if (phase == 1) {
        if (card.beanType == player().hand.peekLast().beanType && player().CanPlantBean(card.beanType) && plantedCounter < 2) {
          player().PlantBean(card.beanType, true);
          plantedCounter++;
          mainButton.clickable = true;
        }
      } else card.selected = !card.selected;
    }

    counter++;
  }

  for (int i = 0; i < 2; i++) {
    if (beanCards[i] != null && beanCards[i].MouseOver() && player().CanPlantBean(beanCards[i].beanType)) {
      player().PlantBean(beanCards[i].beanType, false);
      plantedCounter++;
      beanCards[i] = null;
    }
  }
}

void mouseReleased() {
  if (mainButton.MouseOver() && mainButton.clickable) {
    mainButton.Clicked();
  }
  for (int i = 0; i < 3; i++) {
    if (harvestFieldButtons[i].MouseOver() && harvestFieldButtons[i].clickable) {
      harvestFieldButtons[i].Clicked();
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    player().numCoins++;
  }
}
