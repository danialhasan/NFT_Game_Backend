async function main() {
  const gameContractFactory = await hre.ethers.getContractFactory('Game');
  const gameContract = await gameContractFactory.deploy(
    ['Elon Musk', 'Amirul Daiyan', 'Sham Spam', 'Shah'],

    [
      'https://cdn.mos.cms.futurecdn.net/VSy6kJDNq2pSXsCzb6cvYF.jpg',
      'https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/cat_relaxing_on_patio_other/1800x1200_cat_relaxing_on_patio_other.jpg',
      'https://www.thesprucepets.com/thmb/QDw4vt7XXQejL2IRztKeRLow6hA=/2776x1561/smart/filters:no_upscale()/cat-talk-eyes-553942-hero-df606397b6ff47b19f3ab98589c3e2ce.jpg',
      'https://th-thumbnailer.cdn-si-edu.com/bZAar59Bdm95b057iESytYmmAjI=/1400x1050/filters:focal(594x274:595x275)/https://tf-cmsv2-smithsonianmag-media.s3.amazonaws.com/filer/95/db/95db799b-fddf-4fde-91f3-77024442b92d/egypt_kitty_social.jpg',
    ],
    [150, 200, 120, 500],
    [400, 200, 320, 95]
  );
  await gameContract.deployed();
  console.log('Deployed contract to ', gameContract.address);

  let txn;

  txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();


  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();

  txn = await gameContract.mintCharacterNFT(3);
  await txn.wait();

  let returnedTokenURI = await gameContract.tokenURI(1);
  console.log('Token URI: ', returnedTokenURI);
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
