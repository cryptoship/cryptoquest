import React, { Component } from 'react';
import Pillow from '../../components/Pillow';
import character from '../../dto/character';
import web3 from '../../utils/web3';
import game from '../../utils/game';
import {
  generateRandomCharacter,
  getItemIdsByAddress,
  getCharacterIdsByAddress,
  getItemDetails,
  getCharacterDetails,
  generateRandomItem,
  goIntoDungeon,
  equip
} from '../../utils/api';

export default class Landing extends Component {
  state = {
    account: '',
    characters: '',
    items: [],
    character: { name: '', stats: '' },
    characterIndex: 0,
    itemIndex: 1,
    itemDetails: '',
    dungeonNumber: 0,
    characterId: 0,
    head: 0,
    neck: 0,
    body: 0,
    feet: 0,
    leftHand: 0,
    rightHand: 0
  };
  async componentDidMount() {
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts[0] });
  }

  getCharacter = async () => {
    let characters = await getCharacterIdsByAddress(this.state.account);
    this.setState({ characters });
  };

  getCharacterDeets = async () => {
    let character = await getCharacterDetails(this.state.characterIndex, this.state.account);
    this.setState({ character: { stats: character[0], name: character[1] } });
  };

  generateCharacter = async () => {
    await generateRandomCharacter(0, 'Derek3', this.state.account);
  };

  getItemIdsByAddress = async () => {
    let items = await getItemIdsByAddress(this.state.account);
    this.setState({ items });
  };

  generateItem = async () => {
    await generateRandomItem(this.state.account);
  };

  getItemDetailsByIndex = async () => {
    let details = await getItemDetails(this.state.itemIndex, this.state.account);
    this.setState({ itemDetails: details[1] });
  };

  goToDungeonWithItems = async () => {
    let characterData = await getCharacterDetails(this.state.characterIndex, this.state.account);
    console.log('characterData', characterData);
    let char = character.fromData(characterData);
    console.log('character', char);

    await goIntoDungeon(this.state.characterIndex, char.itemIds, this.state.dungeonNumber, this.state.account);
  };

  equipItem = async => {
    let itemArray = [];
    itemArray.push(this.state.head);
    itemArray.push(this.state.neck);
    itemArray.push(this.state.body);
    itemArray.push(this.state.feet);
    itemArray.push(this.state.leftHand);
    itemArray.push(this.state.rightHand);

    console.log('itemArray', itemArray)
    
    equip(this.state.characterId, itemArray, this.state.account);
  };

  updateCharIndex = e => {
    let v = e.target.value;
    this.setState({ characterIndex: v });
  };

  updateItemIndex = e => {
    let v = e.target.value;
    this.setState({ itemIndex: v });
  };

  //charIndex
  // updatecharIndex = e => {
  //   let v = e.target.value;
  //   this.setState({ charIndex: v });
  // };
  //dungonNumber
  updateDungeonNumber = e => {
    let v = e.target.value;
    this.setState({ dungeonNumber: v });
  };

  updateCharacterId = e => {
    let v = e.target.value;
    this.setState({ characterId: v });
  };

  updateItemIdsArray = e => {
    let v = e.target.value;
    this.setState({ itemIdsArray: v });
  };

  equipHead = e => {
    let v = e.target.value;
    this.setState({ head: v });
  };

  equipNeck = e => {
    let v = e.target.value;
    this.setState({ neck: v });
  };

  equipBody = e => {
    let v = e.target.value;
    this.setState({ body: v });
  };

  equipFeet = e => {
    let v = e.target.value;
    this.setState({ feet: v });
  };

  equipLeftHand = e => {
    let v = e.target.value;
    this.setState({ leftHand: v });
  };

  equipRightHand = e => {
    let v = e.target.value;
    this.setState({ rightHand: v });
  };

  render() {
    return (
      <div>
        <h2>Landing</h2>
        <button onClick={this.generateCharacter}>Generate character</button>
        <button onClick={this.getCharacter}>Get character</button>
        <button onClick={this.getCharacterDeets}>Get character details</button>
        <input value={this.state.characterIndex} onChange={this.updateCharIndex} />

        <button onClick={this.generateItem}>Generate items</button>
        <button onClick={this.getItemIdsByAddress}>Get item id's</button>
        <button onClick={this.getItemDetailsByIndex}>Get item details</button>
        <input value={this.state.itemIndex} onChange={this.updateItemIndex} />

        <button onClick={this.goToDungeonWithItems}>Go To Dungeon</button>
        <input value={this.state.characterIndex} onChange={this.updateCharIndex} />
        <input value={this.state.dungeonNumber} onChange={this.updateDungeonNumber} />

        <div>
          <button onClick={this.equipItem}>Equip item(s)</button>
          <input value={this.state.characterId} onChange={this.updateCharacterId} />
          head
          <input value={this.state.head} onChange={this.equipHead} />
          neck
          <input value={this.state.neck} onChange={this.equipNeck} />
          body
          <input value={this.state.body} onChange={this.equipBody} />
          feet
          <input value={this.state.feet} onChange={this.equipFeet} />
          leftHand
          <input value={this.state.leftHand} onChange={this.equipLeftHand} />
          rightHand
          <input value={this.state.rightHand} onChange={this.equipRightHand} />
        </div>

        <div>
          <div>characters token array</div>
          <div>{this.state.characters}</div>
          <div>character</div>
          <div>{this.state.character.name}</div>
          <div>{this.state.character.stats}</div>
          <div>items</div>
          <div>{this.state.items}</div>
          <div>item details</div>
          <div>{this.state.itemDetails}</div>
        </div>
      </div>
    );
  }
}
