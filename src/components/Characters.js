import React, { Component } from 'react';
import styled from 'styled-components';
import Character from './Character';

export default class Characters extends Component {
  render() {
    return (
      <div>
        Characters
        <GridOfChar>
          <Character />
          <Character />
          <Character />
        </GridOfChar>
      </div>
    );
  }
}

const GridOfChar = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fit, 250px);
  grid-gap: 20px;
  justify-content: center;
  margin-top: 20px;
`;
