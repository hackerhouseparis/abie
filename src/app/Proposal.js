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
    addressContract: null,
    delegate: null,
    metaContract: null,
    accounts:null
  }

  componentDidMount() {
    let testAbie = ''
    setTimeout(() => {
      if (typeof web3 !== 'undefined') {
        // web3 = new Web3(web3.currentProvider);
        this.setState({web3: true})
        let meta = contract(AbieFund)
        this.setState({metaContract: meta})
        let provider = new Web3.providers.HttpProvider(`http://${TESTRPC_HOST}:${TESTRPC_PORT}`)
        let metaCoinBalance = 0
        meta.setProvider(provider)
        const web3RPC = new Web3(provider)
            // Get accounts.
        web3RPC.eth.getAccounts(function(error, acc) {
        return meta.deployed()
          .then((contract) => {
            this.setState({addressContract: contract.address})
            console.log(this.state)
            return contract.setDelegate(
              0,
              acc[0],
              {from: acc[1]}
            )}
          )
          .then((result) => console.log(result))
          .catch((err) => {
            console.error(err);
          })
          console.log(acc)
        })



      } else {
        alert("install Metamask or use Mist");
      }
    }, 1000)
  }

  handleChangeDelegate = (event) => {
    this.setState({delegate: event.target.value});
  }

  setDelegate = (address) => {
    this.state.metaContract.at(this.state.addressContract)
      .then((contract) => contract.setDelegate(
        0,
        this.state.delegate,
        {from: '0x77282410cee8ee341510d966fa33845c1859e1f0'}
      ))
      .then((result) => console.log(result))
      .catch((err) => {
        console.error(err);
      })
  }

  render() {
    return (
      <div id="container">
        <h1>Abie</h1>
        <ul>
          <li>Balance : {this.state.balance}</li>
        </ul>
        <ul>
          <li>
            Set Delegate <input type="text" onChange={this.handleChangeDelegate} />
            <button onClick={this.setDelegate}>Submit address</button>
          </li>
        </ul>
      </div>
    )
  }
}

export default Proposal
