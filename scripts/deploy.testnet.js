async function main() {
  const { provider, BigNumber, utils } = ethers;
  const ETH = utils.parseEther('1');
  const accounts = await ethers.provider.listAccounts()
  const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';
  console.log('owner address', accounts[0])
  const FreeMint721NFT = await ethers.getContractFactory("FreeMint721NFT");

  // loot free mint: 0x97bB866F735f53D6C9F2E1a75FF16FA90B8EA017
  // const freeMint = await FreeMint721NFT.deploy(
  //   "Free Mint NFT",
  //   "FM",
  //   "staging-api.de-fine.art/api/tokens/",
  //   100,
  //   1688014800,
  //   1719550800,
  //   10,
  //   ZERO_ADDRESS,
  //   0
  // )
  // console.log('FreeMint721NFT ADDRESS:', freeMint.address)
  const freeMint = await FreeMint721NFT.attach("0x97bB866F735f53D6C9F2E1a75FF16FA90B8EA017")
  const a = await freeMint.mint();
  console.log(a);
}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error);
  process.exit(1);
});
