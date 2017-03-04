import React, {Component} from 'react'
import request from 'superagent'
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'
import AbieFund from '../../build/contracts/AbieFund.json'

import '../www/styles/Proposal.scss'

const TESTRPC_HOST = 'localhost'
const TESTRPC_PORT = '8545'

class Proposal extends Component {

  state = {
    web3: false,
    balance: 0,
  }

  componentDidMount() {
    let testAbie = ''
    setTimeout(() => {
      if (typeof web3 !== 'undefined') {
        // web3 = new Web3(web3.currentProvider);
        this.setState({web3: true})
        let meta = contract(AbieFund)
        let provider = new Web3.providers.HttpProvider(`http://${TESTRPC_HOST}:${TESTRPC_PORT}`)
        let metaCoinBalance = 0
        meta.setProvider(provider)
        meta.deployed(['0x77282410cee8ee341510d966fa33845c1859e1f0', '0x63f2b18dced715721520d9a024886c7797be9e0e'])
          .then((instance) => {
            let contract = instance;
            testAbie = `Metacoin address: ${instance.address}`
            return contract.setDelegate(0,'0x77282410cee8ee341510d966fa33845c1859e1f0',{from: '0x77282410cee8ee341510d966fa33845c1859e1f0'})
          // }).then((result) => {
          //   this.setState({balance: result.toNumber()})
          //   return contract.setDelegate(0,'0x77282410cee8ee341510d966fa33845c1859e1f0',{from: '0x77282410cee8ee341510d966fa33845c1859e1f0'})
          }).then((result) => {
            console.log(result)
          }).catch(function(err) {
            console.error(err)
          });
      } else {
        alert("install Metamask or use Mist");
      }
    }, 1000)
  }

  render() {
    return (
      <div id="container">
        <h1>Abie</h1>
        <ul>
          <li>Balance : {this.state.balance}</li>
        </ul>
      </div>
    )
  }
}

export default Proposal
