class Character {
  static fromData(data) {
    const props = data[0];
    if (props.length !== 15) {
      throw new Error(`array length should be 15. Instead it's ${props.length}`);
    }

    return new Character(
      data[1] /*name*/,
      props[0] /*tokenId*/,
      props[1] /*characterType*/,
      props[2] /*level*/,
      props[3] /*health*/,
      props[4] /*strength*/,
      props[5] /*dexterity*/,
      props[6] /*intelligence*/,
      props[7] /*wisdom*/,
      props[8] /*charaisma*/,
      props.slice(9) /*itemIds*/
    );
  }

  constructor(name, tokenId, characterType, level, health, strength, dexterity, intelligence, wisdom, charisma, itemIds) {
    this.name = name;
    this.tokenId = tokenId;
    this.characterType = characterType;
    this.level = level;
    this.health = health;
    this.strength = strength;
    this.dexterity = dexterity;
    this.intelligence = intelligence;
    this.wisdom = wisdom;
    this.charisma = charisma;
    this.itemIds = itemIds.slice();
  }
}

Character.EMPTY_ITEMS = [0, 0, 0, 0, 0, 0];

module.exports = Character;
