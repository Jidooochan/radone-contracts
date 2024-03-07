require("@nomicfoundation/hardhat-toolbox");
require("hardhat-contract-sizer");
require('dotenv').config()

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337,
      allowUnlimitedContractSize: true,
    },
    fuji: {
      url: process.env.AVALANCHE_FUJI_RPC || "",
      accounts: [process.env.FUJI_TEST_PRIVATE_KEY || "0x90ad449DEb987A1f34D5127751874E9BBD223F2f"],
    },
    radone_local: {
      url: process.env.RADONE_LOCAL_RPC || "",
      accounts: [process.env.RADONE_TEST_PRIVATE_KEY || "0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC"],
    },
    customer_local: {
      url: process.env.CUSTOMER_LOCAL_RPC || "",
      accounts: [process.env.RADONE_TEST_PRIVATE_KEY || "0x8db97C7cEcE249c2b98bDC0226Cc4C2A57BF52FC"],
    },
  },
};
