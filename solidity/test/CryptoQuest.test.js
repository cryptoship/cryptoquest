const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const {interface, bytecode} = require('../compile');

const provider = ganache.provider();
const web3 = new Web3(provider);

let accounts;
let cryptoQuest;

class Item {
	constructor(array, name, description) {
		if(array.length !== 7) {
			throw new Error(`array length should be 7. Instead it's ${array.length}`)
		}
		this.tokenId = array[0];
		this.slot = array[1];
		this.armor = array[2];
		this.damage = array[3];
		this.attackSpeed = array[4];
		this.evasion = array[5];
		this.blockChance = array[6];
	}
}

class Character {
	constructor(data) {
		const props = data[0]
		if(props.length !== 15) {
			throw new Error(`array length should be 15. Instead it's ${props.length}`);
		}
		this.name = data[1]
		this.tokenId = props[0];
		this.characterType = props[1];
		this.level = props[2];
		this.health = props[3];
		this.strength = props[4];
		this.dexterity = props[5];
		this.intelligence = props[6];
		this.wisdom = props[7];
		this.charisma = props[8];
		this.itemIds = props.slice(9);
	}
}

beforeEach(async () => {
	accounts = await web3.eth.getAccounts();

	cryptoQuest = await new web3.eth.Contract(JSON.parse(interface))
	    .deploy({ data: bytecode})
	    .send({from: accounts[0], gas : '5000000'})

	cryptoQuest.setProvider(provider);
});

describe('CryptoQuest', () => {
	it('deploys a contract', () => {
		console.log('Address: ', cryptoQuest.options.address);
		assert.ok(cryptoQuest.options.address)
	});

	it('owner is deployer', async () => {
		const owner = await cryptoQuest.methods.owner().call();
		assert.equal(accounts[0], owner);
	});

	it('user can not set characterBasePrice', async () => {
		try {
		  await cryptoQuest.methods.setCharacterBasePrice(100).send({from: accounts[1]});
	      assert(false);
		} catch(e) {
	      assert.ok(e);
	    }
	});

	it('owner can set characterBasePrice', async () => {
		await cryptoQuest.methods.setCharacterBasePrice(100).send({from: accounts[0]});
		const price = await cryptoQuest.methods.getCharacterBasePrice().call();
		assert.equal(100, price);
	});

	it('user can not set random numbers', async () => {
		try {
		  await cryptoQuest.methods.setRandomNumbers([1, 2, 3]).send({from: accounts[1]});
	      assert(false);
		} catch(e) {
	      assert.ok(e);
	    }
	});

	it('user can not get random numbers', async () => {
		try {
		  await cryptoQuest.methods.getRandomNumbers().call();
	      assert(false);
		} catch(e) {
	      assert.ok(e);
	    }
	});

	it('owner can set random numbers', async () => {
	    await cryptoQuest.methods.setRandomNumbers([1, 2, 3]).send({from: accounts[0], gas : '1000000'});
	    const numbers = await cryptoQuest.methods.getRandomNumbers().call();
		assert.deepEqual([1,2,3], numbers);
	});

  it('users can generate a random character', async () => {
      await cryptoQuest.methods.setRandomNumbers([0, 0]).send({from: accounts[0], gas : '1000000'});
      await cryptoQuest.methods.setCharacterBasePrice(100).send({from: accounts[0]});

      await cryptoQuest.methods.generateRandomCharacter(0, 'Derek').send({from: accounts[1], gas : '1000000', value: 100});

      const charIdArray = await cryptoQuest.methods.getCharacterIdsByAddress(accounts[1]).call({from: accounts[0], gas : '1000000'});

      assert.equal(1, charIdArray.length);
      const data = await cryptoQuest.methods.getCharacter(charIdArray[0]).call({from: accounts[0], gas : '5000000'});

			const character = new Character(data);

      assert.equal(1, character.tokenId);  // tokenId
      assert.equal(0, character.characterType);  // characterType
      assert.equal(1, character.level);  // level

      assert.equal(5, character.health);
      assert.equal(5, character.strength);
      assert.equal(5, character.dexterity);

      assert.equal(5, character.intelligence);
      assert.equal(5, character.wisdom);
      assert.equal(5, character.charisma);

			assert.deepEqual([0,0,0,0,0,0], character.itemIds)
			assert.equal('Derek', character.name)
  });

	it('user can not set itemBasePrice', async () => {
		try {
		  await cryptoQuest.methods.setItemBasePrice(100).send({from: accounts[1]});
	      assert(false);
		} catch(e) {
	      assert.ok(e);
	    }
	});

	it('owner can set itemBasePrice', async () => {
		await cryptoQuest.methods.setItemBasePrice(100).send({from: accounts[0]});
		const price = await cryptoQuest.methods.getItemBasePrice().call();
		assert.equal(100, price);
	});

  it('users can generate a random item', async () => {
      await cryptoQuest.methods.setRandomNumbers([0, 0]).send({from: accounts[0], gas : '1000000'});
      await cryptoQuest.methods.setItemBasePrice(100).send({from: accounts[0]});

      await cryptoQuest.methods.generateRandomItem().send({from: accounts[1], gas : '1000000', value: 100});

      const itemIdArray = await cryptoQuest.methods.getItemIdsByAddress(accounts[1]).call({from: accounts[0], gas : '1000000'});

      assert.equal(1, itemIdArray.length);
      const array = await cryptoQuest.methods.getItem(itemIdArray[0]).call({from: accounts[0], gas : '5000000'});

      const propertiesArray = array[0];
      assert.equal(itemIdArray[0], propertiesArray[0]);

      assert.equal(5, propertiesArray[1]);
      assert.equal(0, propertiesArray[2]);
      assert.equal(9, propertiesArray[3]);
      assert.equal(5, propertiesArray[4]);
      assert.equal(2, propertiesArray[5]);
      assert.equal(1, propertiesArray[6]);
      assert.equal("Dagger of doom", array[1]);  // characterType
      assert.equal("", array[2]);  // level
  });

	it('equips an item to a character', async () => {
		//generate an item
		await cryptoQuest.methods.setRandomNumbers([0, 0]).send({from: accounts[0], gas : '1000000'});
		await cryptoQuest.methods.setItemBasePrice(100).send({from: accounts[0]});
		await cryptoQuest.methods.generateRandomItem().send({from: accounts[1], gas : '1000000', value: 100});
		const itemIdArray = await cryptoQuest.methods.getItemIdsByAddress(accounts[1]).call({from: accounts[0], gas : '1000000'});
		assert.equal(1, itemIdArray.length);
		const generatedItemId = itemIdArray[0]
		const itemArray = await cryptoQuest.methods.getItem(generatedItemId).call({from: accounts[0], gas : '5000000'});

		//generate a character
		await cryptoQuest.methods.setCharacterBasePrice(100).send({from: accounts[0]});
		await cryptoQuest.methods.generateRandomCharacter(0, 'Derek').send({from: accounts[1], gas : '1000000', value: 100});
		const charIdArray = await cryptoQuest.methods.getCharacterIdsByAddress(accounts[1]).call({from: accounts[0], gas : '1000000'});
		assert.equal(1, charIdArray.length);
		const characterData = await cryptoQuest.methods.getCharacter(charIdArray[0]).call({from: accounts[0], gas : '5000000'});
		// character should have a name ???
		const character = new Character(characterData)

		await cryptoQuest.methods.equip(character.tokenId, [generatedItemId,0,0,0,0,0]).send({from: accounts[1], gas : '1000000'});

		const updatedCharacterData = await cryptoQuest.methods.getCharacter(charIdArray[0]).call({from: accounts[0], gas : '5000000'});
		const updatedCharacter = new Character(updatedCharacterData)

		assert.deepEqual([generatedItemId,0,0,0,0,0], updatedCharacter.itemIds)
	})

});
