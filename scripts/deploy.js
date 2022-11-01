// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;
  // const lockedAmount = hre.ethers.utils.parseEther("1");
  // const Lock = await hre.ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });
  // await lock.deployed();
  // console.log(
  //   `Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
  // );

  const initialSupply = 10 ** 8;
  const vestingPeriod = 365; // 12 months;
  const amountToRelease = 2500000; ////tokens;
  const tokenReleaseInterval = 131400; // 3 months in minutes

  // sending 50,000 every 2628 minutes

  const VestingContract = await hre.ethers.getContractFactory("Vesting");
  const contract = await VestingContract.deploy(
    initialSupply,
    vestingPeriod,
    amountToRelease,
    tokenReleaseInterval
  );

  await contract.deployed();

  console.log("Contract deployed: ", contract.address);
  // //console.log(`Verify with:\n npx hardhat verify --network networkName ${token.address} ${initialSupply}`)
  // npx hardhat verify --network mumbai_testnet 0x6b4Fd6D9Fed25C9925a2B238503B45B8b75ee51d 100000000 365 2500000 131400
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
