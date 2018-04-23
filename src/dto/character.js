class Character {
  static fromData(data) {
    const props = data[0];
    if (props.length !== 18) {
      throw new Error(`array length should be 18. Instead it's ${props.length}`);
    }

    return new Character(

      // uint256 tokenId;

      // // attributes of the character
      // uint8 characterType;
      // uint8 level;
      // uint8 health;
      // uint8 damage;
      // uint8 fireResistance;
      // uint8 iceResistance;
      // uint8 poisonResistance;
      // // items the Character is wearing
      // uint[6] items;
      // string name;

      // bool forSale;
      // uint price;
      // uint8 currentHealth;
      // uint healthTime;

      data[1] /*name*/,
      props[0] /*tokenId*/,
      props[1] /*characterType*/,
      props[2] /*level*/,
      props[3] /*health*/,
      props[4] /*damage*/,
      props[5] /*fireResistance*/,
      props[6] /*iceResistance*/,
      props[7] /*posionResistance*/,
      props[8] /*forSale*/,
      props[9] /*price*/,
      props[10] /*currentHealth*/,
      props[11] /*healthTime*/,
      props.slice(12) /*itemIds*/
    );

    // return (array, c.name);
  }

  constructor(name, tokenId, characterType, level, health, damage,
    fireResistance, iceResistance, poisonResistance, forSale, price,
    currentHealth, healthTime, itemIds) {
    this.name = name;
    this.tokenId = tokenId;
    this.characterType = characterType;
    this.level = level;
    this.health = health;
    this.damage = damage;
    this.fireResistance = fireResistance;
    this.iceResistance = iceResistance;
    this.poisonResistance = poisonResistance;
    this.forSale = !!+forSale;
    this.price = price;
    this.currentHealth = +currentHealth;
    this.healthTime = healthTime;
    this.itemIds = itemIds.slice();
  }
}

Character.EMPTY_ITEMS = ['0', '0', '0', '0', '0', '0'];

module.exports = Character;
