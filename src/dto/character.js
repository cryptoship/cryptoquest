class Character {
  static fromData(data) {
    const props = data[0];
    if (props.length !== 14) {
      throw new Error(`array length should be 14. Instead it's ${props.length}`);
    }

    return new Character(
      data[1] /*name*/,
      props[0] /*tokenId*/,
      props[1] /*characterType*/,
      props[2] /*level*/,
      props[3] /*health*/,
      props[4] /*damage*/,
      props[5] /*fireResistance*/,
      props[6] /*iceResistance*/,
      props[7] /*posionResistance*/,
      props.slice(8) /*itemIds*/
    );

    return (array, c.name);
  }

  constructor(name, tokenId, characterType, level, health, damage, fireResistance, iceResistance, poisonResistance, itemIds) {
    this.name = name;
    this.tokenId = tokenId;
    this.characterType = characterType;
    this.level = level;
    this.health = health;
    this.damage = damage;
    this.fireResistance = fireResistance;
    this.iceResistance = iceResistance;
    this.poisonResistance = poisonResistance;
    this.itemIds = itemIds.slice();
  }
}

Character.EMPTY_ITEMS = ['0', '0', '0', '0', '0', '0'];

module.exports = Character;
