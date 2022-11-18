const {expect,assert} = require("chai");
const {ethers}  = require("hardhat");

describe("StoringOwner",function () {
   
    let storingowner;
    let deployer;
    let address1;
    let address2;
   
    beforeEach(async function () {
       [deployer,address1,address2] = await ethers.getSigners();
       console.log(deployer);
        const StoringOwner = await ethers.getContractFactory("StoringOwner");
      storingowner = await StoringOwner.deploy();
     await storingowner.deployed();
   });

   it("Should have Deployed Successfully",async function () {
      console.log("success");
   });

   it("Should store the owner address",async function () {
      const owner = await storingowner.owner.call();
      assert.equal(owner,deployer.address);
   });
});