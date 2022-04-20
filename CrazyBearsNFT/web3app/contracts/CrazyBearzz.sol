// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract CrazyBearzz is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    mapping(address => bool) public excludedList;
    uint excludedCounter = 0;

    struct Trade {
        uint256 index;
        address poster;
        uint256 item;
        uint256 price;
        bytes32 status;
    }

    mapping(uint256 => Trade) public trades;
    uint public tradeCounter = 0;

    uint public constant MAX_SUPPLY = 100;
    uint public PRICE = 0.01 ether;
    uint public constant MAX_PER_MINT = 3;
    mapping(uint256 => bool) public onSale;

    mapping(string => uint8) public existingURIs;
    Counters.Counter private _tokenIdCounter;
    string public baseTokenURI = "ipfs://ipQmXPjJb1yF6CJ64iWmw6GfjcmongHv8nLuD5D821PsoEBw/";

    constructor() ERC721("CrazyBearzz", "CB") {}

    // set price
    function setPrice(uint256 _price) public onlyOwner{
        PRICE = _price;
    }

    // set the excluded list
    function setExcluded(address excluded, bool status) public onlyOwner {
        require(msg.sender == address(this), "owner only");
        excludedList[excluded] = status;
        excludedCounter = excludedCounter + 1;
    }

    // safeMint for owner
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function isContentOwned(string memory uri) public view returns (bool) {
        return existingURIs[uri] == 1;
    }

    function payToMint(string memory metadataURI)
     public payable returns (uint256) {

        if(excludedList[msg.sender] == false) // sender not in excludedList 
            require(msg.value >= PRICE, "Pay up!");

        uint newItemId = _tokenIdCounter.current();
        existingURIs[metadataURI] = 1;
        _safeMint(msg.sender, newItemId);
        onSale[newItemId] = false;
        _tokenIdCounter.increment();

        return newItemId;
    }

    function count() public view returns (uint256){
        return _tokenIdCounter.current();
    }

    function tokensOfOwner(address _owner) external view returns (uint[] memory) {

        uint tokenCount = balanceOf(_owner);
        uint[] memory tokensId = new uint256[](tokenCount);

        for (uint i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    function getActiveTrades() external view returns (Trade[] memory){
        uint currentIndex = 0;
        // count opened trades
        for (uint i = 0; i < tradeCounter; i++) {
            if(trades[i].status == "Open"){
                currentIndex = currentIndex + 1;
            }
        }
        // list opened trades
        Trade[] memory activeTrades = new Trade[](currentIndex);
        uint crt = 0;
        for (uint i = 0; i < tradeCounter; i++) {
            if(trades[i].status == "Open"){
                activeTrades[crt] = trades[i];
                crt += 1;
            }
        }

        return activeTrades;
    }

    // sell
    function sellTrade(uint256 _item, uint256 _price)
    public
    {
        require(_exists(_item), "Token ID not available");
        require(msg.sender == ownerOf(_item), "Not owner of this token");
        require(_price > 0, "Pay up!");

        // check if token is already on sale
        for (uint i = 0; i < tradeCounter; i++) {
            if(trades[i].status == "Open" && trades[i].item == _item){
                require(false, "Token already on sale!");
            }
        }
        // approve contarct to transfer token
        approve(address(this), _item);
        trades[tradeCounter] = Trade({
            index: tradeCounter,
            poster: msg.sender,
            item: _item,
            price: _price,
            status: "Open"
        });
        tradeCounter += 1;
        onSale[_item] = true;
    }

    // buy
    function buyTrade(uint256 _trade)
    public
    payable
    {
        Trade memory trade = trades[_trade];
        require(trade.status == "Open", "Trade is not Open.");
        require(trade.poster != msg.sender, "No permission");
        require(msg.value >= trade.price, "Pay the price !!!");
        // contract trasnfers token the buyer
        this.transferFrom(trade.poster, msg.sender, trade.item);
        payable(trade.poster).transfer(msg.value);
        trades[_trade].status = "Finished";
        onSale[trade.item] = false;
    }
    
    // cancel trade
    function cancelTrade(uint256 _trade)
    public
    {
        Trade memory trade = trades[_trade];
        require(
            msg.sender == trade.poster,
            "No permission to cancel!"
        );
        require(trade.status == "Open", "This trade is not available!.");
        trades[_trade].status = "Cancelled";
        onSale[trade.item] = false;
    }

    // returns true if token is on sale
    function getItemStatus(uint256 item) public view returns(bool){
        return onSale[item];
    }

}