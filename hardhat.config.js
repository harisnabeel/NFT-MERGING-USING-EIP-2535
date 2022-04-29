
/* global ethers task */
require('@nomiclabs/hardhat-waffle')

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
async function getContractInstance() {
  const diamondContract = await ethers.getContractFactory("Diamond");
  const diamondContractInstance = await diamondContract.attach(
    "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512"
  );
  return diamondContractInstance;
}})

task("balancecheck","checksBalance", async()=>{
      const accounts = await hre.ethers.getSigners();
    // Create the contract instance
    const diamond =  await ethers.getContractAt('LIBERC1155FACET', "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512");
    const bal = await diamond.balanceOf("0xe7f1725e7734ce288f8367e1bb143e90bb3f0512",1);
    console.log(bal.toString());
})

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.6',
  settings: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
}
