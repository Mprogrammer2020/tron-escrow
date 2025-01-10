const Escrow = artifacts.require("Escrow");

contract("Escrow", (accounts) => {
  const [owner, seller, buyer, arbitrator] = accounts;
  let escrowInstance;

  before(async () => {
    escrowInstance = await Escrow.deployed();
  });

  it("should create an escrow", async () => {
    const amount = web3.utils.toWei("1", "ether");
    await escrowInstance.createEscrow(buyer, amount, { from: seller, value: amount });

    const escrow = await escrowInstance.escrows(1);
    assert.equal(escrow.buyer, buyer, "Buyer address is incorrect");
    assert.equal(escrow.amount, amount, "Escrow amount is incorrect");
    assert.equal(escrow.status, "created", "Escrow status is incorrect");
  });

  it("should release escrow", async () => {
    const escrowId = 1;

    await escrowInstance.releaseEscrow(escrowId, { from: seller });

    const escrow = await escrowInstance.escrows(escrowId);
    assert.equal(escrow.status, "released", "Escrow status is not 'released'");
  });

  it("should allow cancellation of escrow", async () => {
    const amount = web3.utils.toWei("1", "ether");
    await escrowInstance.createEscrow(buyer, amount, { from: seller, value: amount });

    const escrowId = 2;

    await escrowInstance.cancelEscrow(escrowId, { from: seller });

    const escrow = await escrowInstance.escrows(escrowId);
    assert.equal(escrow.status, "cancelled", "Escrow status is not 'cancelled'");
  });

  it("should allow the arbitrator to resolve disputes", async () => {
    await escrowInstance.setArbitrator(arbitrator, { from: owner });

    const amount = web3.utils.toWei("1", "ether");
    await escrowInstance.createEscrow(buyer, amount, { from: seller, value: amount });

    const escrowId = 3;
    await escrowInstance.resolveDispute(escrowId, buyer, { from: arbitrator });

    const escrow = await escrowInstance.escrows(escrowId);
    assert.equal(escrow.status, "cancelled", "Escrow status is not 'cancelled'");
  });
});
