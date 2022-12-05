const {ethers,upgrades} = require("hardhat");
async function main() {
    const CounterV2 = await ethers.getContractFactory("CounterV2");
    const counterV2 = await upgrades.upgradeProxy("0xf7906D737Dd9dDf6f3e916cc3E1767990A9A9900",CounterV2);
    console.log("Contract Upgraded");
}
main();