import java.util.*;

enum beanTypes {
  cocoa, garden, red, black, soy, green, stink, chili, blue, wax, coffee
};

PImage coinImage;
PImage thirdFieldImage;
PImage backgroundImage;
Map<beanTypes, PImage> beanImages = new HashMap();
Stack deck = new Stack<beanTypes>();
Stack discard = new Stack<beanTypes>();
LinkedList<Player> players = new LinkedList<Player>();


void setup()
{
  // set dimensions
  size(1600, 900);
  
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
    for (int i = 0; i < 5; i++)
      player.hand.add((beanTypes)deck.pop());
  }
  
}

void draw() {
  image(backgroundImage,0,0);
  players.getFirst().DrawHand(true);
}
