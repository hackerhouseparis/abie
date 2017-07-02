var AbieFund = artifacts.require("./AbieFund.sol");
let m1, m2, m3, m4, candidate;
let abie; // abie is an abstraction of the main contract "AbieFund.sol"

contract('AbieFund', (accounts)=> {
  before(async ()=> {
    abie = await AbieFund.deployed()
    m1 = accounts[0]
    m2 = accounts[1]
    m3 = accounts[2]
    m4 = accounts[3]
    candidate = accounts[4]
  })

  it("m2 set delegate", ()=> {
    return abie.setDelegate(0,m1,{from: m2})
    .then(() => abie.getDelegate.call(m2,0))
    .then(result => assert.equal(result, m1))
  })

  it("candidate ask for membership", ()=> {
    return abie.askMembership({value: web3.toWei(1, "ether") ,from: candidate})
    .then(() => abie.proposals.call(0))
    .then(result => assert.equal(result[3], candidate))
  })

  it("proposal is published", function() {
    return abie.addProposal(0x0, 1, 0x0, {value: web3.toWei(1, "ether") ,from: candidate})
    .then(result => abie.proposals.call(0))
    .then(result => {
      //result[3] => proposal.recipient
      assert.equal(result[3], candidate, "error add proposal")
      return abie.nbProposalsFund()})
    .then(result => assert.equal(result, 1, "error count proposals"))
  })

  /*it("test vote", function() {
    return abie.vote(0,1 ,{from: m3})
    .then(function() {
      return abie.countAllVotes(0)})
      .then(function(result) {
      console.log(result);
      // result[3] => proposal.recipient
      assert.equal(result, 1 )
    })
  })*/
})
