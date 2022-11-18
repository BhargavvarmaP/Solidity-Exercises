const {ethers} = require("hardhat");

async function main() {
    const SimpleStorage = await ethers.getContractFactory("SimpleStorage");
    const simplestorage = await SimpleStorage.deploy();
    await simplestorage.deployed();
    
    console.log("Contract deployed at address :",simplestorage.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  