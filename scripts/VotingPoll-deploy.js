const {ethers} = require("hardhat");

async function main() {
    const VotingPoll = await ethers.getContractFactory("VotingPoll");
    const votingpoll = await VotingPoll.deploy();
    await votingpoll.deployed();
    
    console.log("Contract deployed at address :",votingpoll.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  