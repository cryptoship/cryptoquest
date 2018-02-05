import React, { Component } from 'react'
import styled from 'styled-components'

import { Link } from 'react-router-dom'

export default class Navigation extends Component {
  render() {
    return (
      <NavigationContainer>
        <Left>
          <TitleLink to="/">Title</TitleLink>
        </Left>
        <Middle>
          <MainLink to="/inventory">Inventory</MainLink>
          <MainLink to="/market">Market</MainLink>
          <MainLink to="/play">Play</MainLink>
        </Middle>
        <Right>{/* nothing here yet */}</Right>
      </NavigationContainer>
    )
  }
}

const NavigationContainer = styled.div`
  background: #eee;
  border-bottom: 1px solid #e5e5e5;
  display: flex;
  height: 60px;
`

const Left = styled.div`
  flex: 1;
  display: flex;
  align-items: center;
  padding: 0 20px;
`

const Middle = styled.div`
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0 20px;
`

const Right = styled.div`
  flex: 1;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding: 0 20px;
`

const TitleLink = styled(Link)`
  color: #22386f;
  text-decoration: none;
  font-size: 1.7em;
`

const MainLink = styled(Link)`
  color: #22386f;
  text-decoration: none;
  font-size: 1.4em;
  padding: 0 10px;
`
