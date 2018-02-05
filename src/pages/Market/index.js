import React, { Component } from 'react'
import { Link } from 'react-router-dom'
export default class Markey extends Component {
  render() {
    return (
      <div>
        <h2>Market</h2>
        <Link to="market/items">Items</Link>
        <Link to="market/characters">Characters</Link>
      </div>
    )
  }
}
