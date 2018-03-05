class Item {

  static fromData(data) {
    var array = data[0];

    if (array.length !== 7) {
      throw new Error(`array length should be 7. Instead it's ${array.length}`);
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
      array[6]
    );
  }

  constructor(name, description, tokenId, slot, armor, damage, attackSpeed, evasion, blockChance) {
    this.name = name;
    this.description = description;
    this.tokenId = tokenId;
    this.slot = slot;
    this.armor = armor;
    this.damage = damage;
    this.attackSpeed = attackSpeed;
    this.evasion = evasion;
    this.blockChance = blockChance;
  }
}

module.exports = Item;
