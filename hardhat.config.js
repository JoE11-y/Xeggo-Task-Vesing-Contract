require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "mumbai_testnet",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    hardhat: {},
    mumbai_testnet: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.RPC_API_KEY}`,
      chainId: 80001,
      accounts: [`0x${process.env.ACCOUNT_KEY}`],
    },
    polygon_mainnet: {
      url: "https://polygon-rpc.com/",
      chainId: 137,
      accounts: [`0x${process.env.ACCOUNT_KEY}`],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  solidity: "0.8.9",
};
