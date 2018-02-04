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
});