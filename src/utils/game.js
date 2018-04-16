import web3 from './web3';

const address = '0x7603fc20095f1bcb814f0aa1ef67d0632ab6e6b1';

const abi = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "characterId",
				"type": "uint8"
			},
			{
				"name": "itemIds",
				"type": "uint256[6]"
			},
			{
				"name": "dungeonId",
				"type": "uint256"
			}
		],
		"name": "goIntoDungeon",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "itemId",
				"type": "uint256"
			}
		],
		"name": "getItem",
		"outputs": [
			{
				"name": "",
				"type": "uint256[7]"
			},
			{
				"name": "",
				"type": "string"
			},
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "getItemBasePrice",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "a",
				"type": "address"
			}
		],
		"name": "getItemIdsByAddress",
		"outputs": [
			{
				"name": "",
				"type": "uint256[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "itemIds",
				"type": "uint256[6]"
			}
		],
		"name": "getItemDamageAndArmor",
		"outputs": [
			{
				"name": "",
				"type": "uint8"
			},
			{
				"name": "",
				"type": "uint8"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "generateRandomItem",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "characterId",
				"type": "uint256"
			},
			{
				"name": "itemIds",
				"type": "uint256[6]"
			}
		],
		"name": "equip",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "getRandomNumbers",
		"outputs": [
			{
				"name": "",
				"type": "uint8[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "getCharacterBasePrice",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "characterId",
				"type": "uint256"
			}
		],
		"name": "buyCharacter",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "a",
				"type": "address"
			}
		],
		"name": "getCharacterIdsByAddress",
		"outputs": [
			{
				"name": "",
				"type": "uint256[]"
			}
		],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "characterId",
				"type": "uint256"
			}
		],
		"name": "getCharacterDetails",
		"outputs": [
			{
				"name": "",
				"type": "uint256[14]"
			},
			{
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "owner",
		"outputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "characterType",
				"type": "uint8"
			},
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "health",
				"type": "uint8"
			},
			{
				"name": "damage",
				"type": "uint8"
			},
			{
				"name": "fireResistance",
				"type": "uint8"
			},
			{
				"name": "iceResistance",
				"type": "uint8"
			},
			{
				"name": "poisonResistance",
				"type": "uint8"
			}
		],
		"name": "generateCharacter",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "numbers",
				"type": "uint8[]"
			}
		],
		"name": "setRandomNumbers",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "basePrice",
				"type": "uint256"
			}
		],
		"name": "setCharacterBasePrice",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "itemId",
				"type": "uint256"
			}
		],
		"name": "buyItem",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "basePrice",
				"type": "uint256"
			}
		],
		"name": "setItemBasePrice",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "characterType",
				"type": "uint8"
			},
			{
				"name": "name",
				"type": "string"
			}
		],
		"name": "generateRandomCharacter",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	}
]
export default new web3.eth.Contract(abi, address);
