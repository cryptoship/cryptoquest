import React, { Component } from 'react';
import { Switch, Route } from 'react-router-dom';
import { withRouter } from 'react-router';
import PageWrapper from './components/PageWrapper';
import './App.css';

import Landing from './pages/Landing';
import About from './pages/About';
import Inventory from './pages/Inventory';
import Play from './pages/Play';
import Market from './pages/Market';
import Items from './components/Items';
import Characters from './components/Characters';
import web3 from './utils/web3.js';
import game from './utils/game';

class App extends Component {
  async componentDidMount() {
    // console.log(cryptoQuest)
    const accounts = await web3.eth.getAccounts();

    // let player = await game.methods
    //   .generateCharacter(0, 'derek1', 10, 10, 40, 20, 10)
    //   .send({ from: accounts[0], value: web3.utils.toWei('0.2', 'ether') });

    let player = await game.methods
      .generateRandomCharacter(0, 'Derek')
      .send({ from: accounts[0], gas: '1000000', value: 100 });

    console.log(player);
  }

  render() {
    return (
      <div className="App">
        <PageWrapper />
        <Switch>
          <Route exact path="/" component={Landing} />
          <Route exact path="/about" component={About} />
          <Route exact path="/play" component={Play} />
          <Route exact path="/inventory" component={Inventory} />
          <Route exact path="/market" component={Market} />
          <Route exact path="/market/items" component={Items} />
          <Route exact path="/market/characters" component={Characters} />
        </Switch>
      </div>
    );
  }
}

export default withRouter(App);
