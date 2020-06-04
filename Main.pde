import java.util.*;

enum beanTypes {
  cocoa, garden, red, black, soy, green, stink, chili, blue, wax, coffee
};

PImage buttonImage;
PFont font;
Card[] beanCards;
Card[] enemyBeanCards;
PImage buttonDownImage;
PImage coinImage;
PImage thirdFieldImage;
PImage backgroundImage;
final float heightScalar = 2.80;
final float widthScalar = 4.33;
Button mainButton;
Button[] harvestFieldButtons;
int currentAI = 0;
int plantedCounter = 0;
int phase = 0;
int beanWidth;
int beanHeight;
Map<beanTypes, PImage> beanImages = new HashMap();
Map<beanTypes, int[]> beanValues = new HashMap();
Stack deck = new Stack<beanTypes>();
Stack discard = new Stack<beanTypes>();
LinkedList<Player> players = new LinkedList<Player>();
Player player() {
  return players.getFirst();
}


void setup()
{
  // set dimensions
  beanCards = new Card[2];
  beanCards[0] = null;
  beanCards[1] = null;

  enemyBeanCards = new Card[2];
  enemyBeanCards[0] = null;
  enemyBeanCards[1] = null;

  font  = createFont("bold.ttf", 48);
  textAlign(CENTER, CENTER);
  fill(#ffffff);
  noStroke();
  //fullScreen();
  size(1920, 1000);
  beanWidth = (int)(height / widthScalar);
  beanHeight = (int)(height / heightScalar);

  InitializeBeans();
  buttonImage = loadImage("button.png");
  buttonDownImage = loadImage("buttondown.png");

  mainButton = new Button(width / 2 - (int)(height / 3.18) / 2, height / 2 - (int)(height / 10f) / 2, (int)(height / 3.18), (int)(height / 10f), "Next", -1);
  harvestFieldButtons = new Button[3];

  for (int i = 0; i < 3; i++) {
    harvestFieldButtons[i] = new Button((int)(width / 4 * 3 + beanWidth / 3 + (beanWidth / 1.9 * i)), height / 20, beanWidth / 2, beanWidth / 6, "Harvest", i);
  }

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

  incrementPhase();
}

void draw() {
  textFont(font);
  image(backgroundImage, 0, 0);
  player().RenderBeanFields();
  mainButton.Render();
  RenderDeck();
  RenderCoins();

  RenderEnemyBeans();

  Iterator<Player> iterator = players.iterator();
  while (iterator.hasNext()) {
    Player player = iterator.next();
    player.RenderHand();
    player.RenderBeanFields();
    //player.aI.Phase1(player);
  }

  if (phase == 3 || phase == 4 || phase == 5) {
    if (player().HasSelectedBeans() && EnemyBeansSelected()) {
      mainButton.text = "Propose Trade";
      mainButton.clickable = true;
    } else {
      mainButton.text = "Next";
      if (plantedCounter != 2) {
        mainButton.clickable = false;
      } else {
        mainButton.clickable = true;
      }
    }
  }
}

boolean EnemyBeansSelected() {

  for (int i = 0; i < 2; i++) {
    if (enemyBeanCards[i] != null && enemyBeanCards[i].selected == true) return true;
  }
  return false;
}

void RenderEnemyBeans() {

  for (int i = 0; i < 2; i++) {
    if (enemyBeanCards[i] != null) {
    
      if (enemyBeanCards[i].selected) translate(0, -beanHeight / 16);
      image(beanImages.get(enemyBeanCards[i].beanType), beanWidth + (players.get(currentAI).hand.size() + 1) * beanWidth / 12 + (beanWidth / 2 * i), beanHeight * (currentAI - 1) + beanHeight / 2, beanWidth / 2, beanHeight / 2);
      if (enemyBeanCards[i].selected) translate(0, beanHeight / 16);
    }
  }
}

int MouseOverEnemyBeans(){

  for (int i = 0; i < 2; i++) {
    if (enemyBeanCards[i] != null) {
      
      if (mouseX > beanWidth + (players.get(currentAI).hand.size() + 1) * beanWidth / 12 + (beanWidth / 2 * i) && mouseX < beanWidth + (players.get(currentAI).hand.size() + 1) * beanWidth / 12 + (beanWidth / 2 * i) + beanWidth / 2){
        if (mouseY > beanHeight * (currentAI - 1) + beanHeight / 2 && mouseY < beanHeight * (currentAI - 1) + beanHeight) {
          return i;
        }
      }
      
    }
  }
  
  return -1;
  
}

void OfferTrade(){

  
  
}

void UpdateBeanFields() {
  boolean hasMoreThanOne = false;

  for (int i = 0; i < player().maxBeanFields; i++) {
    if (player().beanFieldAmounts[i] > 1) {
      hasMoreThanOne = true;
    }
  }

  for (int i = 0; i < player().maxBeanFields; i++) {
    if (hasMoreThanOne && player().beanFieldAmounts[i] == 1) {
      harvestFieldButtons[i].clickable = false;
    } else {
      harvestFieldButtons[i].clickable = true;
    }
  }
}

void RenderDeck() {
  for (int i = 0; i < deck.size() / 5; i++) {
    image(coinImage, width / 3 + width / 30 + i * 2, height / 30);
  }

  for (int i = 0; i < 2; i++) {
    if (beanCards[i] != null) {
      int val = (beanCards[i].MouseOver()) ? 1 : 0;
      image(beanImages.get(beanCards[i].beanType), beanCards[i].x, beanCards[i].y + beanHeight / 25 * val);
    }
  }
}

void RenderCoins() {
  for (int i = 0; i < player().numCoins; i++) {
    image(coinImage, width - beanWidth + i * 2, height - beanHeight / 1.5, beanWidth / 2, beanHeight / 2);
  }
  fill(#ffffff);
  text("Coins: " + player().numCoins, width - beanWidth, height - beanHeight);
}


public beanTypes DrawCard() {

  beanTypes bean = (beanTypes)deck.pop();

  if (deck.size() == 0) {
    while (discard.size() > 0) {
      deck.push(discard.pop());
    }
    Collections.shuffle(deck);
  }

  return bean;
}

void incrementPhase() {
  plantedCounter = 0;
  phase++;
  if (phase > 4) {
    phase = 1;
  }

  if (phase == 1) {
    mainButton.clickable = false;
    mainButton.text = "Next";
    player().hand.peekLast().selected = true;
    player().hand.get(player().hand.size() - 2).selected = true;
  } else if (phase == 2) {
    player().hand.peekLast().selected = false;
    beanCards = new Card[2];
    beanCards[0] = new Card(DrawCard(), width / 3 + width / 80 + 0 * 2 + beanWidth * (0 + 1) + beanWidth / 2, height / 30);
    beanCards[1] = new Card(DrawCard(), width / 3 + width / 80 + 1 * 2 + beanWidth * (1 + 1) + beanWidth / 2, height / 30);
    plantedCounter = 0;
  } else if (phase == 3) {
    currentAI = 1;
    beanCards[0] = null;
    beanCards[1] = null;
    incrementPhase();
  } else if (phase == 4) {
    players.get(currentAI).aI.Phase1(players.get(currentAI));
  } else if (phase == 5) {
    players.get(currentAI).aI.Phase2(players.get(currentAI));
  } else if (phase == 6) {
    if (currentAI <= 2) {
      phase = 3;
      players.get(currentAI).aI.Phase3(players.get(currentAI));
      currentAI++;
      incrementPhase();
    } else {
      phase = 0;
      currentAI = 0;
      incrementPhase();
    }
  }
}
