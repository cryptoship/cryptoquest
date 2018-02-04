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
	
	/*it('it updates message', async () => {
		await inbox.methods.setMessage('bye').send({from: accounts[0]});
		const message = await inbox.methods.message().call();
		assert.equal('bye', message);
	});*/
});