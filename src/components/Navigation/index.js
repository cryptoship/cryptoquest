import React, { Component } from 'react'
import styled from 'styled-components'

import { Link, NavLink } from 'react-router-dom'

export default class Navigation extends Component {
  render() {
    return (
      <NavigationContainer>
        <Left>
          <TitleLink to="/">Title</TitleLink>
        </Left>
        <Middle>
          <MainLink to="/inventory" activeClassName="active">
            Inventory
          </MainLink>
          <MainLink to="/market" activeClassName="active">
            Market
          </MainLink>
          <MainLink to="/play" activeClassName="active">
            Play
          </MainLink>
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
  font-size: 1.7em;
  text-decoration: none;
  padding-bottom: 3px;
`

const MainLink = styled(NavLink)`
  color: #22386f;
  text-decoration: none;
  font-size: 1.4em;
  padding: 0 10px 8px 10px;
  &.active {
    padding-bottom: 5px;
    border-bottom: 3px solid #22386f;
  }
`
