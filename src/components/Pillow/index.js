import React, { Component } from 'react'
import styled from 'styled-components'

export default class Pillow extends Component {
  render() {
    return <PillowCase>Pillow</PillowCase>
  }
}

const PillowCase = styled.div`
  padding: 20px 10px;
  margin: 10px;
  border: 1px solid #eee;
  border-radius: 3px;
  background: #fafafa;
`
