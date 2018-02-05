import React, { Component } from 'react';
import styled from 'styled-components';

export default class Character extends Component {
  state = {
    name: 'Joe',
    img: 'https://cdn.petcarerx.com/LPPE/images/articlethumbs/Cat-Scratch-Fever-Small.jpgs',
    health: 7,
    dex: 9,
    wisdom: 8,
    intel: 6,
    strength: 12,
    value: 23
  };
  render() {
    return (
      <div>
        <div>
          <div>Name:</div>
          <div>{this.state.name}</div>
          <div>health</div>
          <div>{this.state.health}</div>
          <div>dex</div>
          <div>{this.state.dex}</div>
          <div>intel</div>
          <div>{this.state.intel}</div>
          <div>wisdom</div>
          <div>{this.state.wisdom}</div>
          <div>ETH:</div>
          <div>{this.state.value}</div>
        </div>
      </div>
    );
  }
}
