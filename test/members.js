/*****

Testing isValidMember() in "AbieFund.sol" :

function isValidMember(address m) constant returns(bool) {
    if (members[m].registration==0) // Not a member.
        return false;
    if (members[m].registration+registrationTime<now) // Has expired.
        return false;
    return true;
}

*****/

var AbieFund = artifacts.require("./AbieFund.sol")
let m1, m2, m3, m4, candidate
let abie, m1Valid, valid

contract('AbieFund', (accounts)=> {
  before(async ()=> {
    abie = await AbieFund.deployed()
  })

  it("m1 is a valid member", () => {
    m1 = accounts[0]
    return abie.isValidMember(m1)
    m1Valid = abie.isValidMember(m1)
    assert.isTrue(m1Valid, "m1 is not a valid member")
  })

  it("m2 is a valid member", () => {
    m2 = accounts[1]
    return abie.isValidMember(m2)
    m2Valid = abie.isValidMember(m2)
    assert.isTrue(m2Valid, "m2 is not a valid member")
  })

  it("m3 is a valid member", () => {
    m3 = accounts[2]
    return abie.isValidMember(m3)
    m3Valid = abie.isValidMember(m3)
    assert.isTrue(m3Valid, "m3 is not a valid member")
  })

  it("m4 is a valid member", () => {
    m4 = accounts[3]
    return abie.isValidMember(m4)
    m4Valid = abie.isValidMember(m4)
    assert.isTrue(m4Valid, "m4 is not a valid member")
  })

  it("candidate is NOT a valid member : he's just a candidate! ;)", () => {
    candidate = accounts[4]
    return abie.isValidMember(candidate)
    candidateValid = abie.isValidMember(candidate)
    assert.isTrue(candidateValid, "candidate seems to be a valid memmber and that's weird...")
  })
})
