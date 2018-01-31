import React, { Component } from 'react'
import { Switch, Route } from 'react-router-dom'
import { withRouter } from 'react-router'

import './App.css'

import Index from './pages/Index'
import About from './pages/About'

class App extends Component {
  render() {
    return (
      <div className="App">
        <Switch>
          <Route exact path="/" component={Index} />
          <Route exact path="/about" component={About} />
        </Switch>
      </div>
    )
  }
}

export default withRouter(App)
