import React, { Component } from 'react';
import Pillow from '../../components/Pillow';

import web3 from '../../utils/web3';
import game from '../../utils/game';
import {
  generateRandomCharacter,
  getItemIdsByAddress,
  getCharacterIdsByAddress,
  getItemDetails,
  getCharacterDetails,
  generateRandomItem,
  goIntoDungeon
} from '../../utils/api';

export default class Landing extends Component {
  state = {
    account: '',
    characters: '',
    items: [],
    character: { name: '', stats: '' },
    characterIndex: 1,
    itemIndex: 1,
    itemDetails: '',
    charIndex: 0,
    dungonNumber: 0
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
    console.log(character);
    this.setState({ character: { stats: character[0], name: character[1] } });
  };

  generateCharacter = async () => {
    await generateRandomCharacter(0, 'Derek3', this.state.account);
  };

  getItemIdsByAddress = async () => {
    let items = await getItemIdsByAddress(this.state.account);
    // console.log('items', items);
    this.setState({ items });
  };

  generateItem = async () => {
    await generateRandomItem(this.state.account);
  };

  getItemDetailsByIndex = async () => {
    let details = await getItemDetails(this.state.itemIndex, this.state.account);
    this.setState({ itemDetails: details[1] });
  };

  goToDungeonWithItems = async charIndex => {
    let items = await getItemIdsByAddress(this.state.account);
    console.log('items', items);
    await goIntoDungeon(this.state.charIndex, items, this.state.dungonNumber, this.state.account);
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
  updatecharIndex = e => {
    let v = e.target.value;
    this.setState({ charIndex: v });
  };
  //dungonNumber
  updateDungonNumber = e => {
    let v = e.target.value;
    this.setState({ dungonNumber: v });
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
        <input value={this.state.charIndex} onChange={this.updatecharIndex} />
        <input value={this.state.dungonNumber} onChange={this.updateDungonNumber} />

        <div>
          <div>characters</div>
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
