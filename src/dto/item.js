class Item {

  static fromData(data) {
    var array = data[0];

    if (array.length !== 9) {
      throw new Error(`array length should be 9. Instead it's ${array.length}`);
    }

    return new Item(
      data[1],
      data[2],
      array[0],
      array[1],
      array[2],
      array[3],
      array[4],
      array[5],
      array[6],
      array[7],
      array[8]
    );
  }

  constructor(name, description, tokenId, slot, armor,
    damage, fireResistance, iceResistance, poisonResistance, forSale,
    price) {
    this.name = name;
    this.description = description;
    this.tokenId = tokenId;
    this.slot = slot;
    this.armor = armor;
    this.damage = damage;
    this.fireResistance = fireResistance;
    this.iceResistance = iceResistance;
    this.poisonResistance = poisonResistance;
    this.forSale = forSale;
    this.price = price;
  }
}

module.exports = Item;
