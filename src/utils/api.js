import web3 from './web3';
import game from './game';

export const equip = (characterId, itemArray, account) => {
  game.methods.equip(characterId, itemArray).send({ from: account });
};

export const generateRandomCharacter = (characterType, name, account) => {
  game.methods.generateRandomCharacter(characterType, name).send({ from: account, value: 1000 });
};

export const getCharacterDetails = (characterId, account) => {
  return game.methods.getCharacterDetails(characterId).call({ from: account });
};

export const getCharacterIdsByAddress = account => {
  return game.methods.getCharacterIdsByAddress(account).call({ from: account });
};

export const getItemIdsByAddress = account => {
  return game.methods.getItemIdsByAddress(account).call({ from: account });
};

export const getItemDetails = (index, account) => {
  return game.methods.getItem(index).call({ from: account });
};

export const generateRandomItem = account => {
  game.methods.generateRandomItem().send({ from: account, value: 100 });
};

export const goIntoDungeon = (charIndex, items, dungonNumber, account) => {
  console.log('charIndex', charIndex);
  console.log('items', items);
  console.log('dungonNumber', dungonNumber);
  game.methods.goIntoDungeon(charIndex, items, dungonNumber).send({ from: account });
};
