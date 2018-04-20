import web3 from './web3';
import game from './game';

export const equip = (characterId, itemIds, account) => {
  return game.methods.equip(characterId, itemIds).send({ from: account });
};

export const generateRandomCharacter = (characterType, name, account) => {
  return game.methods.generateRandomCharacter(characterType, name).send({ from: account, value: 100 });
};

// export const equip = (characterId, itemIds, account) => {
//   //character.tokenId, [generatedItemId, 0, 0, 0, 0, 0]
//   return game.methods.equip(characterId, itemIds).send({ from: account, value: 100 });
// };


export const goIntoDungeon = (characterId, itemIds,dungeonNumber ,account) => {
  game.methods.goIntoDungeon(characterId, itemIds, dungeonNumber).send({ from: account, gas: '5000000' });
};


export const getCharacterDetails = (characterId,account) => {
  return game.methods.getCharacterDetails(characterId).send({ from: account, gas: '5000000' });
};


export const getItemIdsByAddress = (account) => {
  return game.methods.getItemIdsByAddress(account).call({ from: account });
};




