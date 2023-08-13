const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RepRegistry", function () {
  let registryContract;
  let repToken;
  let treasuryWallet;
  let borrower;
  let schemaUID =
    "0x302ae32a648ad1211352a9cd45b78ef95a5935595b338208e8b49843e87088e6";

  beforeEach(async () => {
    [, treasuryWallet, borrower] = await ethers.getSigners();

    const REPToken = await ethers.getContractFactory("REPToken");
    repToken = await REPToken.deploy(500000, treasuryWallet.address);

    await repToken.deployed();

    const RepRegistry = await ethers.getContractFactory("RepRegistry");
    registryContract = await RepRegistry.deploy(
      repToken.address,
      treasuryWallet.address
    );

    await registryContract.deployed();
  });

  it("should initialize a schema UID", async () => {
    await expect(await registryContract.initSchemaUID(schemaUID))
      .to.emit(registryContract, "SchemaUIDSet")
      .withArgs(schemaUID);
  });

  it("should register a borrower", async () => {
    await expect(await registryContract.registerBorrower(borrower.address))
      .to.emit(registryContract, "BorrowerRegistered")
      .withArgs(borrower.address);
  });

  it("should transfer an equal amount of token to the weight given", async () => {
    await registryContract.initSchemaUID(schemaUID);

    const tokenAmount = ethers.utils.parseUnits("10", 6);
    await repToken
      .connect(treasuryWallet)
      .approve(registryContract.address, tokenAmount);

    const txn = await registryContract.addToRepScore(
      schemaUID,
      borrower.address,
      10
    );
    const receipt = await txn.wait();
    const event = receipt.events.find((event) => event.event === "ScoreAdded");
    const repScore = event.args.repScore;

    let balanceAfterTxn = await repToken.balanceOf(borrower.address);

    expect(repScore).to.equal(balanceAfterTxn);
  });
});
