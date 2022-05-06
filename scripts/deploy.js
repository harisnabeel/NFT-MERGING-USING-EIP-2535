/* global ethers */
/* eslint prefer-const: "off" */
const { getSelectors, FacetCutAction } = require('./libraries/diamond.js')
const main = async () => {


    // const accounts = await ethers.getSigners()
  // const DiamondCutFacet1 = await ethers.getContractFactory('LIBERC1155FACET')
  // const diamondCutFacet1 = await DiamondCutFacet1.deploy()
  // await diamondCutFacet1.deployed()
  // console.log("Deployed at " , diamondCutFacet1.address)
  //   // const accounts = await ethers.getSigners()
  // const DiamondCutFacet2 = await ethers.getContractFactory('LIBERC721FACET')
  // const diamondCutFacet2 = await DiamondCutFacet2.deploy()
  // await diamondCutFacet2.deployed()
  // console.log("Deployed at " , diamondCutFacet2.address)

  const accounts = await ethers.getSigners()
  // const DiamondCutFacet = await ethers.getContractFactory('LIBMAINFACET')
  // const diamondCutFacet = await DiamondCutFacet.deploy(diamondCutFacet2.address,diamondCutFacet1.address)
  // await diamondCutFacet.deployed()
  // console.log("Deployed at " , diamondCutFacet.address)

  // await diamondCutFacet.connect(accounts[0]).mint(accounts[0].address,3, {value:"1"})
  // console.log("Minted Successfully")
  // console.log("Testing")
  // const accounts = await ethers.getSigners()
  // const DiamondCutFacet = await ethers.getContractFactory('LIBERC721FACET')
  // const diamondCutFacet = await DiamondCutFacet.deploy()
  // await diamondCutFacet.deployed()
  // console.log("Deployed at " , diamondCutFacet.address)

  // await diamondCutFacet.connect(accounts[0]).mint(accounts[0].address, {value:"1000000000000000000"})
  // console.log("Minted Successfully")

  // await diamondCutFacet.connect(accounts[0]).createCollection(22222,2);
  // console.log("Minting Successfull");

  // await diamondCutFacet.balanceOf(accounts[0].address,1);

  // const accounts = await ethers.getSigners()

  const contractOwner = accounts[0]

  // deploy DiamondCutFacet
  const DiamondCutFacet = await ethers.getContractFactory('DiamondCutFacet')
  const diamondCutFacet = await DiamondCutFacet.deploy()
  await diamondCutFacet.deployed()
  console.log('DiamondCutFacet deployed:', diamondCutFacet.address)

  // deploy Diamond
  const Diamond = await ethers.getContractFactory('Diamond')
  const diamond = await Diamond.deploy(contractOwner.address, diamondCutFacet.address)
  await diamond.deployed()
  console.log('Diamond deployed:', diamond.address)

  const DiamondInit = await ethers.getContractFactory('DiamondInit')
  const diamondInit = await DiamondInit.deploy()
  await diamondInit.deployed()
  console.log('DiamondInit deployed:', diamondInit.address)

  console.log('')
  console.log('Deploying facets')
  const FacetNames = ['LIBERC1155FACET','DiamondLoupeFacet',
    'OwnershipFacet','LIBMAINFACET','LIBERC721FACET']

    const cut = []
  for (const FacetName of FacetNames) {
    const Facet = await ethers.getContractFactory(FacetName)
    // let facet = 0x00;
   

       facet = await Facet.deploy()
       console.log(FacetName)
    
    await facet.deployed()
    console.log(`${FacetName} deployed: ${facet.address}`)
    console.log("---------------------------", FacetNames.length)
    cut.push({
      facetAddress: facet.address,
      action: FacetCutAction.Add,
      functionSelectors: getSelectors(facet)
    })
  }

  console.log('')
  console.log('Diamond Cut:', cut)
  const diamondCut = await ethers.getContractAt('IDiamondCut', diamond.address)
  let tx
  let receipt
  // call to init function
  let functionCall = diamondInit.interface.encodeFunctionData('init')
  tx = await diamondCut.diamondCut(cut, diamondInit.address, functionCall)
  console.log('Diamond cut tx: ', tx.hash)
  receipt = await tx.wait()
  if (!receipt.status) {
    throw Error(`Diamond upgrade failed: ${tx.hash}`)
  }
  console.log('Completed diamond cut')


  // MINTS 

  const LIBMAINFACET = await ethers.getContractAt('LIBMAINFACET', diamond.address)
  await LIBMAINFACET.initializer("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512","0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9","0xa513E6E4b8f2a923D98304ec87F64353C4D5C853"); // Diamond address and LIBERC1155FACET address in parameters 
  await LIBMAINFACET.connect(accounts[0]).mint_(5,4) // mints to Diamond contract due to context
  await LIBMAINFACET.connect(accounts[0]).mint_(1,4,{value:"1000000000000000000"}) // mints to Diamond contract due to context
  // await LIBMAINFACET.connect(accounts[0]).mint_(1,4,{value:"1000000000000000000"})
  // let bal =  await LIBMAINFACET.balOf(accounts[0].address,1);
  // console.log(bal.toString(), "This is latest balance");
  // await Mainlib.balanceOf(accounts[0].address,1)

// checking balance of erc1155
  const liberc1155Facet = await ethers.getContractAt('LIBERC1155FACET', diamond.address)

  let balance1155 = await liberc1155Facet.balanceOf(accounts[0].address,1) // Diamond address in parameter (which is minting nfts)
  console.log(balance1155.toString(), " = Balance of ERC1155 tokens")
// checking balance of erc721
  const liberc721Facet = await ethers.getContractAt('LIBERC721FACET', diamond.address)

  let balance = await liberc721Facet.balanceOf(accounts[0].address) // Diamond address in parameter (which is minting nfts)
  console.log(balance.toString()," = Balance of ERC721 token")  
  // console.log(accounts[0].address)
  // console.log(a.toString());
  // await diamond.mint(accounts[0].address,3)
  // await lIBERC1155FACET.createCollection(20,2);
    // const Facet = await ethers.getContractFactory("LIBMAINFACET")
    // const facet = await Facet.deploy(diamond.address)
    // await facet.deployed()
    // await facet.mint(accounts[0].address, 4)


  return diamond.address

};                                          

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();


// const { getSelectors, FacetCutAction } = require('./libraries/diamond.js')

// async function deployDiamond () {
//   const accounts = await ethers.getSigners()
//   const contractOwner = accounts[0]

//   // deploy DiamondCutFacet
//   const DiamondCutFacet = await ethers.getContractFactory('DiamondCutFacet')
//   const diamondCutFacet = await DiamondCutFacet.deploy()
//   await diamondCutFacet.deployed()
//   console.log('DiamondCutFacet deployed:', diamondCutFacet.address)

//   // deploy Diamond
//   const Diamond = await ethers.getContractFactory('Diamond')
//   const diamond = await Diamond.deploy(contractOwner.address, diamondCutFacet.address)
//   await diamond.deployed()
//   console.log('Diamond deployed:', diamond.address)

//   // deploy DiamondInit
//   // DiamondInit provides a function that is called when the diamond is upgraded to initialize state variables
//   // Read about how the diamondCut function works here: https://eips.ethereum.org/EIPS/eip-2535#addingreplacingremoving-functions
//   const DiamondInit = await ethers.getContractFactory('DiamondInit')
//   const diamondInit = await DiamondInit.deploy()
//   await diamondInit.deployed()
//   console.log('DiamondInit deployed:', diamondInit.address)

//   // deploy facets
//   console.log('')
//   console.log('Deploying facets')
//   const FacetNames = [
//     'DiamondLoupeFacet',
//     'OwnershipFacet'
//   ]
//   const cut = []
//   for (const FacetName of FacetNames) {
//     const Facet = await ethers.getContractFactory(FacetName)
//     const facet = await Facet.deploy()
//     await facet.deployed()
//     console.log(`${FacetName} deployed: ${facet.address}`)
//     cut.push({
//       facetAddress: facet.address,
//       action: FacetCutAction.Add,
//       functionSelectors: getSelectors(facet)
//     })
//   }

//   // upgrade diamond with facets
//   console.log('')
//   console.log('Diamond Cut:', cut)
//   const diamondCut = await ethers.getContractAt('IDiamondCut', diamond.address)
//   let tx
//   let receipt
//   // call to init function
//   let functionCall = diamondInit.interface.encodeFunctionData('init')
//   tx = await diamondCut.diamondCut(cut, diamondInit.address, functionCall)
//   console.log('Diamond cut tx: ', tx.hash)
//   receipt = await tx.wait()
//   if (!receipt.status) {
//     throw Error(`Diamond upgrade failed: ${tx.hash}`)
//   }
//   console.log('Completed diamond cut')
//   return diamond.address
// }

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
// if (require.main === module) {
//   deployDiamond()
//     .then(() => process.exit(0))
//     .catch(error => {
//       console.error(error)
//       process.exit(1)
//     })
// }

exports.deployDiamond = main
