class AI {

  AI() {
  }

  public void Phase1(Player me) {
    for (int i = 0; i < 2; i++) {
      if (me.CanPlantBean(me.hand.peekLast().beanType)) {
        me.PlantBean(me.hand.peekLast().beanType, true);
      } else {
        me.HarvestField(0);
        me.PlantBean(me.hand.peekLast().beanType, true);
      }
    }

    enemyBeanCards[0] = new Card((beanTypes)deck.pop());
    enemyBeanCards[1] = new Card((beanTypes)deck.pop());

    int counter = 0;
    for (int i = 0; i < 2; i++) {
      if (me.PlantingBeanType(enemyBeanCards[i].beanType)) {
        me.PlantBean(enemyBeanCards[i].beanType, false);
        enemyBeanCards[i] = null;
        counter++;
      }
    }
    
    if (counter == 2){
      incrementPhase();
    }
  }

  public void Phase2(Player me) {
    Phase3(me);
  }

  public void Phase3(Player me) {
  }
}
