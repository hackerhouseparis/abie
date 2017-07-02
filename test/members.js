/*****

Testing isValidMember() in "AbieFund.sol" :

function isValidMember(address m) constant returns(bool) {
    if (members[m].registration==0) // Not a member.
        return false;
    if (members[m].registration+registrationTime<now) // Has expired.
        return false;
    return true;
}

abie.isValidMember(m1) should return "true", but it does NOT and I don't why. 

The contract was deployed from this address.

*****/

var AbieFund = artifacts.require("AbieFund")
let m1, m1Valid
let abie

contract('AbieFund', (accounts)=> {
  before( async ()=> {
    m1 = accounts[0]
    abie = await AbieFund.deployed()
    //console.log(abie)
    //console.log(accounts)
    m1Valid = await abie.isValidMember(m1)
    console.log("  m1Valid =", m1Valid, "\n")
  })

  it("m1 is a valid member", async () => {
    assert.isOk(m1Valid, "m1 is not a valid member")
  })
})
