void InitializeBeans() {

  // load images for coins and third bean fields
  coinImage = loadImage("coin.png");
  coinImage.resize(0, (int)(height / heightScalar));
  thirdFieldImage = loadImage("third.png");
  thirdFieldImage.resize(0, (int)(height / heightScalar));
  backgroundImage = loadImage("background.png");
  backgroundImage.resize(width, 0);

  // load images for all bean types, starting at 4 (cocoa beans)
  int numBeans = 4;

  for (beanTypes bean : beanTypes.values()) { 
    PImage tmpImage = loadImage(bean.toString() + ".png");
    tmpImage.resize(0, (int)(height /  heightScalar));

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
  final int[] gardenBeanValues = {8, 2, 3};
  final int[] cocoaBeanValues = {8, 2, 3, 4};
  
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
