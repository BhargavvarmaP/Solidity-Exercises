const {ethers,upgrades} = require("hardhat");
async function main() {
    const CounterV1 = await ethers.getContractFactory("CounterV1");
    const counterV1 = await upgrades.deployProxy(CounterV1,[20],{initializer:"initialize"});
    await counterV1.deployed();
    console.log("Contract deployed at address :",counterV1.address);
}
main();