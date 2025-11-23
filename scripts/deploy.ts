import { ethers } from "hardhat";

async function main() {
  const comet = "0xYOUR_COMET_ADDRESS"; // e.g. Compound v3 Sepolia address
  const usdc = "0xYOUR_USDC_ADDRESS";

  const LendingVault = await ethers.getContractFactory("LendingVault");
  const vault = await LendingVault.deploy(comet, usdc);
  await vault.waitForDeployment();

  console.log("Vault deployed to:", await vault.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
