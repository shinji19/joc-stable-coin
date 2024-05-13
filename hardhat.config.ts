import { HardhatUserConfig, vars } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const PRIVATE_KEY = vars.get("PRIVATE_KEY");

const config: HardhatUserConfig = {
  solidity: "0.7.6",
  networks: {
    joc_testnet: {
      url: `https://rpc-1.testnet.japanopenchain.org:8545`,
      accounts: [PRIVATE_KEY],
    },
  },
};

export default config;
