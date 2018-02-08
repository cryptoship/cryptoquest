import React, { Component } from 'react';
import styled from 'styled-components';

export default class Character extends Component {
  state = {
    name: 'Joe',
    img: 'https://cdn.petcarerx.com/LPPE/images/articlethumbs/Cat-Scratch-Fever-Small.jpg',
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
        <CharCard>
          <Name>{this.state.name}</Name>
          <Img src={this.state.img} />
          <Skills>
            <div>health {this.state.health}</div>
            <div>dex {this.state.dex}</div>
            <div>intel {this.state.intel}</div>
            <div>wisdom {this.state.wisdom}</div>
          </Skills>
          <Cost>ETH: {this.state.value}</Cost>
        </CharCard>
      </div>
    );
  }
}

const CharCard = styled.div`
  display: grid;
  grid-template-rows: auto auto 100px 50px;
  grid-template-columns: 250px;
  box-shadow: 0px 0px 31px 0px rgba(0, 0, 0, 0.26);
  width: 250px;
`;

const Img = styled.img`
  width: -webkit-fill-available;
`;

const Name = styled.div`
  align-self: center;
  padding: 10px;
  background-color: #d8d8d8;
  font-size: 30px;
  font-weight: 500;
`;

const Skills = styled.div`
  align-self: center;
`;

const Cost = styled.div`
  align-self: center;
  padding: 20px;
  background-color: #d8d8d8;
`;
