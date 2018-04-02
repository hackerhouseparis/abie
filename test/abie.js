var Abie = artifacts.require("Abie")
let m1, m2, candidate
let abie // abie is an abstraction of the main contract "Abie.sol"

contract('Abie', (accounts)=> {
  before(async ()=> {
    abie = await Abie.deployed()
    m1 = accounts[0]
    m2 = accounts[1]
  })

  /*

  This test file needs to be reviewed.

  **/

  it("m2 set delegate", async () => {
    await abie.setDelegate(0,m1,{from: m2})
    .then(() => abie.getDelegate.call(m2,0))
    .then(result => assert.equal(result, m1))
  })

  it("candidate ask for membership", async () => {
    await abie.askMembership({value: web3.toWei(1, "ether") ,from: candidate})
    .then(() => abie.proposals.call(0))
    .then(result => assert.equal(result[3], candidate))
  })

  it("proposal is published", async () => {
    await abie.addProposal(0x0, 1, 0x0, {value: web3.toWei(1, "ether") ,from: candidate})
    .then(result => abie.proposals.call(0))
    .then(result => {
      assert.equal(result[3], candidate, "error add proposal")
      return abie.nbProposalsFund()})
    .then(result => assert.equal(result, 1, "error count proposals"))
  })

  it("test vote", async () => {
    return abie.isValidMember(m1) // Without this line, I get a // "BigNumber Error: new BigNumber() not a number: [object Object]" and I don't know why ^^
    await abie.vote(1, {from: m1})
    const result = await abie.countAllVotes(0)
    assert.equal(result, 1, "error")
  })
})
