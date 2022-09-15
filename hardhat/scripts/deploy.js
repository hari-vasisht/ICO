const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { NFT_Contract_Address } = require("../constants");

async function main() {
  const NFT_Contract = NFT_Contract_Address;
  const crytpoDreamTokenContract = await ethers.getContarctFactory(
    "CryptoDreamToken"
  );
  const deployedCryptoDreamTokenContract = await ethers.deploy(
    crytpoDreamTokenContract
  );
  console.log(
    "CryptoDreamToken Contaract is deployed at:",
    deployedCryptoDreamTokenContract.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
