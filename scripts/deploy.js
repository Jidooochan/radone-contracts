// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const manager = "0x90ad449DEb987A1f34D5127751874E9BBD223F2f";
  const minRound = 808287;

  const drand = await hre.ethers.deployContract("Drand", [manager, minRound]);

  await drand.waitForDeployment();
  console.log(
    `Drand contract with manager: ${manager} and minRound: ${minRound} deployed to ${drand.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
