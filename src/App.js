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


class App extends Component {

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
