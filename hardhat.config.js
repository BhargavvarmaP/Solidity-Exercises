require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    hardhat: {
       forking: {
      url: "https://api.avax.network/ext/bc/C/rpc",
    }
      },
    ropsten: {
      url: "https://ropsten.infura.io/v3/494d651065cf4c159794e084f06ec4d5",
      accounts: ['0cf837e2ab1552a45de172c1231da8fc6bad1c25484dc4ecfabff5550f3b7afb']
    },
    fuji: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts: ["0cf837e2ab1552a45de172c1231da8fc6bad1c25484dc4ecfabff5550f3b7afb"],
  },
  bnbtestnet: {
    url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
    accounts: ["0cf837e2ab1552a45de172c1231da8fc6bad1c25484dc4ecfabff5550f3b7afb"],
},
    goerli: {
      url: "https://eth-goerli.g.alchemy.com/v2/eDxvdMpABSihT2SD2cISYdwz7pJ27fKe",
      accounts: ['0cf837e2ab1552a45de172c1231da8fc6bad1c25484dc4ecfabff5550f3b7afb']
    }
  },
  etherscan:{
    apiKey:'CK2VGNA33FFYCCE3QC2W1VDHQ3R32H65BS' //AValanche Api key snowtrace
  },
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
};
