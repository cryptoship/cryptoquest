import React, { Component } from 'react';
import styled from 'styled-components';
import Character from './Character';

export default class Characters extends Component {
  render() {
    return (
      <div>
        Characters
        <Character />
      </div>
    );
  }
}
