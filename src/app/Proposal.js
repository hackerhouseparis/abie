import React, {Component} from 'react'
import request from 'superagent'
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'
import MetaCoin from '../../build/contracts/MetaCoin.json'

import '../www/styles/Proposal.scss'

class Proposal extends Component {

  state = {
  }

  render() {
    return (
      <div id="container">
        <h1>Abie</h1>
      </div>
    )
  }
}

export default Proposal
