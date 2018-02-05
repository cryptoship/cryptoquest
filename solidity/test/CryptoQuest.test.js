const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const {interface, bytecode} = require('../compile');

const provider = ganache.provider();
const web3 = new Web3(provider);

let accounts;
let cryptoQuest;

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

        await cryptoQuest.methods.generateRandomCharacter(0).send({from: accounts[1], gas : '1000000', value: 100});

        const charIdArray = await cryptoQuest.methods.getCharacterIdsByAddress(accounts[1]).call({from: accounts[0], gas : '1000000'});

        assert.equal(1, charIdArray.length);
        const array = await cryptoQuest.methods.getCharacter(charIdArray[0]).call({from: accounts[0], gas : '5000000'});

        assert.equal(1, array[0]);  // tokenId
        assert.equal(0, array[1]);  // characterType
        assert.equal(1, array[2]);  // level

        assert.equal(5, array[3]);
        assert.equal(5, array[4]);
        assert.equal(5, array[5]);

        assert.equal(5, array[6]);
        assert.equal(5, array[7]);
        assert.equal(5, array[8]);

        assert.equal(0, array[9]);
        assert.equal(0, array[10]);
        assert.equal(0, array[11]);

        assert.equal(0, array[12]);
        assert.equal(0, array[13]);
        assert.equal(0, array[14]);
    });
});