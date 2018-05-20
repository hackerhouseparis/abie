const Abie = artifacts.require("Abie")

contract('Abie', (accounts)=> {
  let member1 = accounts[0]
  let member2 = accounts[1]
  let donor1 = accounts[2]
  let donor2 = accounts[3]
  let beneficiary = accounts[4]

    // constructor
    it("Abie is deployed", async () => {
      let abie = await Abie.new("0x596f","0x596f",[member1,member2])
      let addr = abie.address
      assert.equal(await abie.nbMembers(), 2, 'The deployment was NOT executed correctly.')
    })

    it("The donors make a 2 ETH donation", async () => {
      let abie = await Abie.new("0x596f","0x596f",[member1,member2])
      let donation = web3.toWei(1, 'ether')
      let tx = await web3.eth.sendTransaction({from: donor1, to: abie.address, value: donation})
      let tx2 = await web3.eth.sendTransaction({from: donor2, to: abie.address, value: donation})
      let balance = await abie.contractBalance()
      assert.equal(await abie.contractBalance(), web3.toWei(2, 'ether'), 'Something went wrong.')
    })

    it("donor1 becomes a member", async () => {
      let abie = await Abie.new("0x596f","0x596f",[member1,member2])
      let donation = web3.toWei(1, 'ether')
      let tx = await web3.eth.sendTransaction({from: donor1, to: abie.address, value: donation})
      let tx2 = await web3.eth.sendTransaction({from: donor2, to: abie.address, value: donation})
      await abie.askMembership({value: web3.toWei(0.1, "ether") ,from: donor1})
      await abie.vote(0,1, {from:member1})
      const increaseTime = addSeconds => {
        web3.currentProvider.send({
            jsonrpc: "2.0",
            method: "evm_increaseTime",
            params: [addSeconds], id: 0
        })
      }
      await increaseTime(20000)
      await abie.countVotes(0,20)
      let exec = await abie.isExecutable(0)
      let claim = await abie.executeAddMemberProposal(0,{from:member1})
      let bal = await abie.contractBalance()
      await abie.isValidMember(donor1).then(result => assert.isTrue(result, "oh no"))
    })

    it("member1 selects member2 as delegate", async () => {
      let abie = await Abie.new("0x596f","0x596f",[member1,member2])
      let donation = web3.toWei(1, 'ether')
      let tx = await web3.eth.sendTransaction({from: donor1, to: abie.address, value: donation})
      let tx2 = await web3.eth.sendTransaction({from: donor2, to: abie.address, value: donation})
      await abie.setDelegate(1,member2,{from: member1})
      await abie.getDelegate(member1,1).then(result => assert.equal(result,member2, "oh no"))
    })

    it("The beneficiary submits a proposal", async () => {
      let abie = await Abie.new("0x596f","0x596f",[member1,member2])
      let donation = web3.toWei(1, 'ether')
      let tx = await web3.eth.sendTransaction({from: donor1, to: abie.address, value: donation})
      let tx2 = await web3.eth.sendTransaction({from: donor2, to: abie.address, value: donation})
      await abie.addProposal(0x0, 500000000000000000, 0x0, {value: web3.toWei(0.1, "ether") ,from: beneficiary})
      .then(result => abie.proposals.call(0))
      .then(result => {
        assert.equal(result[3], beneficiary, "can't submit")
        return abie.nbProposalsFund()})
      .then(result => assert.equal(result, 1, "can't submit"))
    })

    it("The members have voted", async () => {
      let abie = await Abie.new("0x596f","0x596f",[member1,member2])
      let donation = web3.toWei(1, 'ether')
      let tx = await web3.eth.sendTransaction({from: donor1, to: abie.address, value: donation})
      let tx2 = await web3.eth.sendTransaction({from: donor2, to: abie.address, value: donation})
      await abie.addProposal(0x0, 500000000000000000, 0x0, {value: web3.toWei(0.1, "ether") ,from: beneficiary})
      await abie.vote(0,1, {from:member1})
      await abie.vote(0,1, {from:member2})
      const increaseTime = addSeconds => {
        web3.currentProvider.send({
            jsonrpc: "2.0",
            method: "evm_increaseTime",
            params: [addSeconds], id: 0
        })
      }
      await increaseTime(20000)
      await abie.countVotes(0,20)
      let exec = await abie.isExecutable(0).then(result => assert.isTrue(result, "oh no"))
    })

    it("The beneficiary takes the requested amount", async () => {
      let abie = await Abie.new("0x596f","0x596f",[member1,member2])
      let donation = web3.toWei(1, 'ether')
      let tx = await web3.eth.sendTransaction({from: donor1, to: abie.address, value: donation})
      let tx2 = await web3.eth.sendTransaction({from: donor2, to: abie.address, value: donation})
      await abie.addProposal(0x0, 500000000000000000, 0x0, {value: web3.toWei(0.1, "ether") ,from: beneficiary})
      await abie.vote(0,1, {from:member1})
      const increaseTime = addSeconds => {
        web3.currentProvider.send({
            jsonrpc: "2.0",
            method: "evm_increaseTime",
            params: [addSeconds], id: 0
        })
      }
      await increaseTime(20000)
      await abie.countVotes(0,20)
      let exec = await abie.isExecutable(0)
      let claim = await abie.claim(0,{from:beneficiary, value:web3.toWei(0.1, "ether")})
      let bal = await abie.contractBalance()
      assert.equal(bal, 1500000000000000000, "not the expected amount")
    })
})
