import React, { Component } from 'react'
import styled from 'styled-components'
import Navigation from '../../components/Navigation'

export default class PageWrapper extends Component {
  render() {
    const { children } = this.props
    return (
      <Wrapper>
        <Navigation />
        <Body>{children}</Body>
      </Wrapper>
    )
  }
}

const Wrapper = styled.div``
const Body = styled.div``
