package processing.test.main;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Main extends PApplet {



enum beanTypes {
  cocoa, garden, red, black, soy, green, stink, chili, blue, wax, coffee
};

PImage coinImage;
PImage thirdFieldImage;
PImage backgroundImage;
final int beanWidth = 160;
final int beanHeight = 247;
Map<beanTypes, PImage> beanImages = new HashMap();
Map<beanTypes, int[]> beanValues = new HashMap();
Stack deck = new Stack<beanTypes>();
Stack discard = new Stack<beanTypes>();
LinkedList<Player> players = new LinkedList<Player>();
public Player player() {
  return players.getFirst();
}


public void setup()
{
  // set dimensions
  

  InitializeBeans();

  // shuffle the deck
  Collections.shuffle(deck);

  // create new players
  players.add(new Player(0));
  players.add(new Player(1));
  players.add(new Player(2));

  // iterate through players and draw cards
  Iterator<Player> iterator = players.iterator();
  while (iterator.hasNext()) {
    Player player = iterator.next();
    player.DrawCards(5);
  }
}

public void draw() {
  image(backgroundImage, 0, 0);
  player().RenderHand();
  player().RenderBeanFields();
}

public void keyPressed() {

  if (key == ' ') {
    players.getFirst().DrawCards(1);
  }
}

public void mousePressed () {

  int counter = 0;
  Iterator<beanTypes> iterator = player().hand.iterator();
  while (iterator.hasNext()) {
    beanTypes bean;
    try {
      bean = iterator.next();
    } 
    catch (ConcurrentModificationException e) {
      return;
    }

    if (counter == player().OverCard() && player().CanPlantBean(bean)) {
      player().PlantBean(bean);
    }

    counter++;
  }
}



class Player
{
  int numCoins;
  int id;
  LinkedList<beanTypes> hand;
  int maxBeanFields;
  beanTypes[] beanFields;
  int[] beanFieldAmounts;
  public int beanY() { 
    return height - 50 - (beanHeight / 2);
  }
  public int beanX() { 
    return width / 2 - (50 * hand.size() / 2);
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
    translate(beanX() + beanWidth / 2, beanY() - beanHeight / 2);

    // iterate through players and draw cards
    Iterator<beanTypes> iterator = hand.iterator();
    while (iterator.hasNext()) {
      beanTypes bean = iterator.next();

      rotate(PI / 2);
      if (counter == OverCard()) {
        translate(-25, 0);
        image(beanImages.get(bean), 0, 0);
        translate(25, 0);
      } else {
        image(beanImages.get(bean), 0, 0);
      }
      rotate(-PI / 2);


      translate(50, 0);
      counter++;
    }

    popMatrix();
  }

  public void RenderBeanFields() {

    pushMatrix();
    translate(width / 4 * 3, height / 32);

    for (int i = 0; i < maxBeanFields; i++) {
      if (beanFieldAmounts[i] == 0){continue;}
      int counter = 0;

      while (counter < beanFieldAmounts[i]) {
        counter++;
        rotate(PI / 2);
        image(beanImages.get(beanFields[i]), 0, 0);
        rotate(-PI / 2);
        translate(0, 50);
      }

      translate(beanWidth + 20, -50 * counter);
    }
    popMatrix();
  }

  public int OverCard() {

    int x = beanX() - beanWidth / 2;
    int y = beanY() - beanHeight / 2;
    int index = -1;
    int counter = 0;

    Iterator<beanTypes> iterator = hand.iterator();
    while (iterator.hasNext()) {
      beanTypes bean = iterator.next();

      if (mouseY >= y && mouseY <= y + beanHeight) {

        if (mouseX >= x && mouseX <= x + beanWidth) {

          index = counter;
        }
      }
      x += 50;
      counter++;
    }

    return index;
  }

  public void DrawCards(int num) {

    for (int i = 0; i < num; i++) {
      hand.add((beanTypes)deck.pop());

      // shuffle
      if (deck.size() == 0) {
        while (discard.size() > 0) {
          deck.push(discard.pop());
        }
        Collections.shuffle(deck);
      }
    }
  }

  public void PlantBean(beanTypes bean) {
    int i = GetField(bean);
    beanFieldAmounts[i]++;
    hand.removeLast();
    beanFields[i] = bean;
  }

  private int GetField(beanTypes bean) {
    int index = 0;
    if (PlantingBeanType(bean)) {
      for (int i = 0; i < maxBeanFields; i++) {
        if (beanFields[i] == bean) index = i;
      }
    } else {
      for (int i = 0; i < maxBeanFields; i++) {
        if (beanFieldAmounts[i] == 0) index = i;
      }
    }
    return index;
  }

  public boolean CanPlantBean(beanTypes bean) {

    return (PlantingBeanType(bean) || HasEmptyField());
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

    for (int i = 0; i < 4; i++) {
      if (beanFieldAmounts[fieldNumber] <= values[i]) {
        numCoins += i + 1;
        for (int l = 0; l < beanFieldAmounts[fieldNumber] - (i + 1); l++) {
          discard.push(beanFields[fieldNumber]);
        }
        break;
      }
    }
  }
}
public void InitializeBeans() {

  // load images for coins and third bean fields
  coinImage = loadImage("coin.png");
  coinImage.resize(0, 160);
  thirdFieldImage = loadImage("third.png");
  thirdFieldImage.resize(0, 160);
  backgroundImage = loadImage("background.png");

  // load images for all bean types, starting at 4 (cocoa beans)
  int numBeans = 4;

  for (beanTypes bean : beanTypes.values()) { 
    PImage tmpImage = loadImage(bean.toString() + ".png");
    tmpImage.resize(0, 160);

    //put beans in the map
    beanImages.put(bean, tmpImage);

    //add beans to the deck in their proper number
    for (int i = 0; i < numBeans; i++) {
      deck.push(bean);
    }

    // incremement number, 4 to 6 to 8 to 10 etc.
    numBeans += 2;
  }

  final int[] coffeeBeanValues = {4, 7, 10, 12};
  final int[] waxBeanValues = {4, 7, 9, 11};
  final int[] blueBeanValues = {4, 6, 8, 10};
  final int[] chiliBeanValues = {3, 6, 8, 9};
  final int[] stinkBeanValues = {3, 5, 7, 8};
  final int[] greenBeanValues = {3, 5, 6, 7};
  final int[] soyBeanValues = {2, 4, 6, 7};
  final int[] blackBeanValues = {2, 4, 5, 6};
  final int[] redBeanValues = {2, 3, 4, 5};
  final int[] gardenBeanValues = {2, 3};
  final int[] cocoaBeanValues = {2, 3, 4};
  
  beanValues.put(beanTypes.coffee, coffeeBeanValues);
  beanValues.put(beanTypes.wax, waxBeanValues);
  beanValues.put(beanTypes.blue, blueBeanValues);
  beanValues.put(beanTypes.chili, chiliBeanValues);
  beanValues.put(beanTypes.stink, stinkBeanValues);
  beanValues.put(beanTypes.green, greenBeanValues);
  beanValues.put(beanTypes.soy, soyBeanValues);
  beanValues.put(beanTypes.black, blackBeanValues);
  beanValues.put(beanTypes.red, redBeanValues);
  beanValues.put(beanTypes.garden, gardenBeanValues);
  beanValues.put(beanTypes.cocoa, cocoaBeanValues);
  
  
}
  public void settings() {  size(1600, 900); }
}
