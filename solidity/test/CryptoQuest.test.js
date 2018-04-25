const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const { interface, bytecode } = require('../compile');
const Character = require('../../src/dto/character');
const Item = require('../../src/dto/item');

const provider = ganache.provider();
const web3 = new Web3(provider);

let accounts;
let cryptoQuest;

beforeEach(async () => {
  accounts = await web3.eth.getAccounts();

  cryptoQuest = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode })
    .send({ from: accounts[0], gas: '6000000' });

  cryptoQuest.setProvider(provider);
});

describe('CryptoQuest', () => {
  it('deploys a contract', () => {
    console.log('Address: ', cryptoQuest.options.address);
    assert.ok(cryptoQuest.options.address);
  });

  it('owner is deployer', async () => {
    const owner = await cryptoQuest.methods.owner().call();
    assert.equal(accounts[0], owner);
  });

  it('user can not set characterBasePrice', async () => {
    try {
      await cryptoQuest.methods.setCharacterBasePrice(100).send({ from: accounts[1] });
      assert(false);
    } catch (e) {
      assert.ok(e);
    }
  });

  it('owner can set characterBasePrice', async () => {
    await cryptoQuest.methods.setCharacterBasePrice(100).send({ from: accounts[0] });
    const price = await cryptoQuest.methods.getCharacterBasePrice().call();
    assert.equal(100, price);
  });

  it('user can not set random numbers', async () => {
    try {
      await cryptoQuest.methods.setRandomNumbers([1, 2, 3]).send({ from: accounts[1] });
      assert(false);
    } catch (e) {
      assert.ok(e);
    }
  });

  it('user can not get random numbers', async () => {
    try {
      await cryptoQuest.methods.getRandomNumbers().call();
      assert(false);
    } catch (e) {
      assert.ok(e);
    }
  });

  it('owner can set random numbers', async () => {
    await cryptoQuest.methods.setRandomNumbers([1, 2, 3]).send({ from: accounts[0], gas: '1000000' });
    const numbers = await cryptoQuest.methods.getRandomNumbers().call();
    assert.deepEqual([1, 2, 3], numbers);
  });

  it('users can generate a random character', async () => {
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setCharacterBasePrice(100).send({ from: accounts[0] });

    await cryptoQuest.methods
      .generateRandomCharacter(0, 'Derek')
      .send({ from: accounts[1], gas: '1000000', value: 100 });

    const charIdArray = await cryptoQuest.methods
      .getCharacterIdsByAddress(accounts[1])
      .call({ from: accounts[0], gas: '1000000' });

    assert.equal(1, charIdArray.length);
    const data = await cryptoQuest.methods
      .getCharacterDetails(charIdArray[0])
      .call({ from: accounts[0], gas: '5000000' });

    const character = Character.fromData(data);

    assert.equal(1, character.tokenId); // tokenId
    assert.equal(0, character.characterType); // characterType
    assert.equal(1, character.level); // level

    assert.equal(5, character.health);
    assert.equal(5, character.damage);
    assert.equal(5, character.fireResistance);

    assert.equal(5, character.iceResistance);
    assert.equal(5, character.poisonResistance);

    assert.deepEqual(Character.EMPTY_ITEMS, character.itemIds);
    assert.equal('Derek', character.name);
  });

  it('users can generate a character', async () => {
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setCharacterBasePrice(100).send({ from: accounts[0] });

    await cryptoQuest.methods
      .generateCharacter(0, 'Derek', 1, 2, 3, 4, 5)
      .send({ from: accounts[1], gas: '1000000', value: 100 });

    const charIdArray = await cryptoQuest.methods
      .getCharacterIdsByAddress(accounts[1])
      .call({ from: accounts[0], gas: '1000000' });

    assert.equal(1, charIdArray.length);
    const data = await cryptoQuest.methods
      .getCharacterDetails(charIdArray[0])
      .call({ from: accounts[0], gas: '5000000' });

    const character = Character.fromData(data);

    assert.equal(1, character.tokenId); // tokenId
    assert.equal(0, character.characterType); // characterType
    assert.equal(1, character.level); // level

    assert.equal(1, character.health);
    assert.equal(2, character.damage);
    assert.equal(3, character.fireResistance);

    assert.equal(4, character.iceResistance);
    assert.equal(5, character.poisonResistance);

    assert.deepEqual(Character.EMPTY_ITEMS, character.itemIds);
    assert.equal('Derek', character.name);
  });

  it('users can not assign more than 70 stats', async () => {
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setCharacterBasePrice(100).send({ from: accounts[0] });

    try {
    await cryptoQuest.methods
      .generateCharacter(0, 'Derek', 0, 0, 0, 30, 41)
      .send({ from: accounts[1], gas: '1000000', value: 100 });
      assert(false);
    } catch (e) {
      assert.ok(e);
    }

    try {
    await cryptoQuest.methods
      .generateCharacter(0, 'Derek', 255, 4, 0, 0, 1)
      .send({ from: accounts[1], gas: '1000000', value: 100 });
      assert(false);
    } catch (e) {
      assert.ok(e);
    }
  });

  it('user can not set itemBasePrice', async () => {
    try {
      await cryptoQuest.methods.setItemBasePrice(100).send({ from: accounts[1] });
      assert(false);
    } catch (e) {
      assert.ok(e);
    }
  });

  it('owner can set itemBasePrice', async () => {
    await cryptoQuest.methods.setItemBasePrice(100).send({ from: accounts[0] });
    const price = await cryptoQuest.methods.getItemBasePrice().call();
    assert.equal(100, price);
  });

  it('users can generate a random item', async () => {
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setItemBasePrice(100).send({ from: accounts[0] });

    await cryptoQuest.methods.generateRandomItem().send({ from: accounts[1], gas: '1000000', value: 100 });

    const itemIdArray = await cryptoQuest.methods
      .getItemIdsByAddress(accounts[1])
      .call({ from: accounts[0], gas: '1000000' });

    assert.equal(1, itemIdArray.length);
      const array = await cryptoQuest.methods.getItem(itemIdArray[0]).call({ from: accounts[0], gas: '5000000' });

    const item = Item.fromData(array);

    const propertiesArray = array[0];
    assert.equal(itemIdArray[0], item.tokenId);

    assert.equal(5, item.slot);
    assert.equal(0, item.armor);
    assert.equal(4, item.damage);
    assert.equal(0, item.fireResistance);
    assert.equal(0, item.iceResistance);
    assert.equal(0, item.poisonResistance);
    assert.equal('Dagger of doom', item.name);
    assert.equal('', item.description);
  });

  it('equips an item to a character', async () => {
    //generate an item
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setItemBasePrice(100).send({ from: accounts[0] });
    await cryptoQuest.methods.generateRandomItem().send({ from: accounts[1], gas: '1000000', value: 100 });
    const itemIdArray = await cryptoQuest.methods
      .getItemIdsByAddress(accounts[1])
      .call({ from: accounts[0], gas: '1000000' });
    assert.equal(1, itemIdArray.length);
    const generatedItemId = itemIdArray[0];
    const itemArray = await cryptoQuest.methods.getItem(generatedItemId).call({ from: accounts[0], gas: '5000000' });



    //generate a character
    await cryptoQuest.methods.setCharacterBasePrice(100).send({ from: accounts[0] });
    await cryptoQuest.methods
      .generateRandomCharacter(0, 'Derek')
      .send({ from: accounts[1], gas: '1000000', value: 100 });
    const charIdArray = await cryptoQuest.methods
      .getCharacterIdsByAddress(accounts[1])
      .call({ from: accounts[0], gas: '1000000' });
    assert.equal(1, charIdArray.length);
    const characterData = await cryptoQuest.methods
      .getCharacterDetails(charIdArray[0])
      .call({ from: accounts[0], gas: '5000000' });
    // character should have a name ???
    const character = Character.fromData(characterData);

    // console.log('equips',character)

    await cryptoQuest.methods
      .equip(character.tokenId, [generatedItemId, 0, 0, 0, 0, 0])
      .send({ from: accounts[1], gas: '1000000' });

    const updatedCharacterData = await cryptoQuest.methods
      .getCharacterDetails(charIdArray[0])
      .call({ from: accounts[0], gas: '5000000' });
    const updatedCharacter = Character.fromData(updatedCharacterData);

    assert.deepEqual([generatedItemId, 0, 0, 0, 0, 0], updatedCharacter.itemIds);
  });


  it('go into dungeon', async () => {
    //generate an item
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setItemBasePrice(100).send({ from: accounts[0] });
    await cryptoQuest.methods.generateRandomItem().send({ from: accounts[1], gas: '1000000', value: 100 });
    const itemIdArray = await cryptoQuest.methods
      .getItemIdsByAddress(accounts[1])
      .call({ from: accounts[1], gas: '1000000' });

    assert.equal(1, itemIdArray.length);
    const generatedItemId = itemIdArray[0];
    const itemArray = await cryptoQuest.methods.getItem(generatedItemId).call({ from: accounts[0], gas: '5000000' });

    //generate a character
    await cryptoQuest.methods.setCharacterBasePrice(100).send({ from: accounts[0] });
    await cryptoQuest.methods
      .generateRandomCharacter(0, 'Derek')
      .send({ from: accounts[1], gas: '1000000', value: 100 });
    const charIdArray = await cryptoQuest.methods
      .getCharacterIdsByAddress(accounts[1])
      .call({ from: accounts[1], gas: '1000000' });
    assert.equal(1, charIdArray.length);

    //set char
    const characterData = await cryptoQuest.methods
      .getCharacterDetails(charIdArray[0])
      .call({ from: accounts[1], gas: '5000000' });
    const character = Character.fromData(characterData);

    //equip item on that char
    await cryptoQuest.methods
      .equip(character.tokenId, [generatedItemId, 0, 0, 0, 0, 0])
      .send({ from: accounts[1], gas: '1000000' });
    const characterData2 = await cryptoQuest.methods
      .getCharacterDetails(charIdArray[0])
      .call({ from: accounts[1], gas: '5000000' });
    const character2 = Character.fromData(characterData2);

    //go to dungeon
    await cryptoQuest.methods
      .goIntoDungeon(character2.tokenId, [generatedItemId, 0, 0, 0, 0, 0], 0)
      .send({ from: accounts[1], gas: '5000000' });
    const itemIdArray2 = await cryptoQuest.methods
      .getItemIdsByAddress(accounts[1])
      .call({ from: accounts[1], gas: '1000000' });
    assert.equal(2, itemIdArray2.length);

    //set char
    const characterData1 = await cryptoQuest.methods
      .getCharacterDetails(charIdArray[0])
      .call({ from: accounts[1], gas: '5000000' });
    const character1 = Character.fromData(characterData1);
    assert.equal(5, character1.currentHealth);
  });

  it('users can set items for sale', async () => {
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setItemBasePrice(100).send({ from: accounts[0] });

    await cryptoQuest.methods.generateRandomItem().send({ from: accounts[1], gas: '1000000', value: 100 });

    const itemIdArray = await cryptoQuest.methods
      .getItemIdsByAddress(accounts[1])
      .call({ from: accounts[0], gas: '1000000' });

    assert.equal(1, itemIdArray.length);
    const array = await cryptoQuest.methods.getItem(itemIdArray[0]).call({ from: accounts[0], gas: '5000000' });
    const item = Item.fromData(array);

    const propertiesArray = array[0];
    assert.equal(itemIdArray[0], item.tokenId);

    assert.equal(5, item.slot);
    assert.equal(0, item.armor);
    assert.equal(4, item.damage);
    assert.equal(0, item.fireResistance);
    assert.equal(0, item.iceResistance);
    assert.equal(0, item.poisonResistance);
    assert.equal('Dagger of doom', item.name);
    assert.equal('', item.description);
    assert.equal(false, item.forSale);

    await cryptoQuest.methods.sendItemToMarketPlace(item.tokenId, 25).send({ from: accounts[1], gas: '1000000' });
    const item2 = Item.fromData(await cryptoQuest.methods.getItem(itemIdArray[0]).call({ from: accounts[0], gas: '5000000' }));

    assert.equal(5, item2.slot);
    assert.equal(0, item2.armor);
    assert.equal(4, item2.damage);
    assert.equal(0, item2.fireResistance);
    assert.equal(0, item2.iceResistance);
    assert.equal(0, item2.poisonResistance);
    assert.equal('Dagger of doom', item2.name);
    assert.equal('', item2.description);
    assert.equal(true, item2.forSale);
    assert.equal(25, item2.price);

    const itemArray = await cryptoQuest.methods.getItemsForSale().call({ from: accounts[1], gas: '1000000' });
    assert.deepEqual([item.tokenId], itemArray);

    await cryptoQuest.methods.removeItemFromMarketPlace(item.tokenId).send({ from: accounts[1], gas: '1000000' });

    const itemArray2 = await cryptoQuest.methods.getItemsForSale().call({ from: accounts[1], gas: '1000000' });
    assert.deepEqual([], itemArray2);
  });

  it('users can set characters for sale', async () => {
    await cryptoQuest.methods.setRandomNumbers([0, 0]).send({ from: accounts[0], gas: '1000000' });
    await cryptoQuest.methods.setItemBasePrice(100).send({ from: accounts[0] });

    await cryptoQuest.methods.generateRandomCharacter(0, 'Derek').send({ from: accounts[1], gas: '1000000', value: 100 });

    const charIdArray = await cryptoQuest.methods
      .getCharacterIdsByAddress(accounts[1])
      .call({ from: accounts[0], gas: '1000000' });

    assert.equal(1, charIdArray.length);
    const array = await cryptoQuest.methods.getCharacterDetails(charIdArray[0]).call({ from: accounts[0], gas: '5000000' });
    const character = Character.fromData(array);
    assert.equal(false, character.forSale);

    await cryptoQuest.methods.sendCharacterToMarketPlace(character.tokenId, 25).send({ from: accounts[1], gas: '1000000' });

    const character2 = Character.fromData(await cryptoQuest.methods.getCharacterDetails(charIdArray[0]).call({ from: accounts[0], gas: '5000000' }));
    assert.equal(true, character2.forSale);
    assert.equal(25, character2.price);

    const charForSaleArray = await cryptoQuest.methods.getCharactersForSale().call({ from: accounts[1], gas: '1000000' });
    assert.deepEqual([character.tokenId], charForSaleArray);

    await cryptoQuest.methods.removeCharacterFromMarketPlace(character.tokenId).send({ from: accounts[1], gas: '1000000' });
    const character3 = Character.fromData(await cryptoQuest.methods.getCharacterDetails(charIdArray[0]).call({ from: accounts[0], gas: '5000000' }));
    assert.equal(false, character3.forSale);

    const charForSaleArray1 = await cryptoQuest.methods.getCharactersForSale().call({ from: accounts[1], gas: '1000000' });
    assert.deepEqual([], charForSaleArray1);
  });
});
