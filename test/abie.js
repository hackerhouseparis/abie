var AbieFund = artifacts.require("./AbieFund.sol");

contract('AbieFund', function(accounts) {
  it("member 2 set delegate for AddMember to member 1", function() {
// 4 membres
// 1 membre set delegate pour AddMember

    var member1 = accounts[0]
    var member2 = accounts[1]
    var member3 = accounts[2]
    var member4 = accounts[3]

    var abieFund
    return AbieFund.new([member1,member2,member3,member4]).then(function(instance) {
      // member 2 set delegate for AddMember to member 1
      abieFund = instance
      return abieFund.setDelegate(0,member1,{from: member2})
    }).then(function() {
      // verify
      return abieFund.getDelegate.call(member2,0)
    }).then(function(result) {
      console.log("res ",result)
      assert.equal(result, member1)
    })
  })

  it("publish a proposal to become a member", function() {
    var member1 = accounts[0]
    var member2 = accounts[1]
    var member3 = accounts[2]
    var member4 = accounts[3]
    var candidate = accounts[4]

    var abieFund;
    return AbieFund.new([member1,member2,member3,member4]).then(function(instance) {
      abieFund = instance
      return abieFund.askMembership({value: web3.toWei(1, "ether") ,from: candidate})
    }).then(function() {
      return abieFund.proposals.call(0)
    }).then(function(result) {
      // result[3] => proposal.recipient
      assert.equal(result[3], candidate )
    })
  })
/*
  it("test vote", function() {
    var member1 = accounts[0]
    var member2 = accounts[1]
    var member3 = accounts[2]
    var member4 = accounts[3]
    var candidate = accounts[4]

    var abieFund;
    return AbieFund.new([member1,member2,member3,member4]).then(function(instance) {
      abieFund = instance
      return abieFund.askMembership({value: web3.toWei(1, "ether") ,from: candidate})
    }).then(function() {
      return abieFund.vote(0,1 ,{from: member3})
    }).then(function() {
      return abieFund.countAllVotes(0)
    }).then(function(result) {
      console.log(result);
      // result[3] => proposal.recipient
      assert.equal(result, 1 )
    })
  })*/

})
