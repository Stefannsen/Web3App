# CrazyBearzz
A web3 application for selling and trading nfts from CrazyBearzz Collection

## About
CrazyBearzz Collection consists of 101 NFTs that represent customized funny bears.
In order to create these images, we created 6 custom layers in Photoshop. The layers were combined by using [this](https://github.com/rounakbanik/generative-art-nft) python script. We also generated json metadata files with this program.


## Install:
1) terminal 1: `npm install`
2) terminal 1: `npx hardhat node`
3) terminal 2: `npx hardhat compile`
4) terminal 2: `npx hardhat run scripts/deploy.js --network localhost`
5) terminal 3: `npm run dev`

## Features
1) Mint NFTs on blockchain for a price + gas fee.
2) Sell NFTs on market.
3) Buy NFTs on market.
4) Cancel a trade on market.

## Functions
1) `setPrice(uint256 price) (onlyOwner)` - The owner can change the mint price.
2) `setExcluded(address excluded, bool status) (onlyOwner)` - Add an address on white list.
3) `safeMint(address to) (onlyOwner)` - The owner can mint a NFT for another account for free (except gas).
4) `isContentOwned(string memory uri)` - True if the token from the specified URI is owner.
5) `payToMint()` - Mint for a price specified in contract.
6) `tokensOfOwner(address _owner)` - Returns all the token ID's owner by an account.
7) `getActiveTrades() ` - Returns all the active trades.
8) `openTrade(uint256 _item, uint256 _price)` - Sell a NFT.
9) `executeTrade(uint256 _trade)` - Buy a NFT.
10) `cancelTrade(uint256 _trade)` - Cancel the trade.
11) getItemStatus(uint256 item) - Returns true if item is currently on sale.

## Technologies
1) Solidity
2) React
3) Hardhat
4) Bootstrap 5
