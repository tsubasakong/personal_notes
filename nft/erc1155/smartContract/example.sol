// SPDX-License-Identifier: MIT

// Into the Metaverse NFTs are governed by the following terms and conditions: https://a.did.as/into_the_metaverse_tc

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import './AbstractERC1155Factory.sol';

/*
* @title ERC1155 token for Adidas cards
* @author Niftydude
*/
contract AdidasOriginals is AbstractERC1155Factory  {

    uint256 constant MAX_SUPPLY = 30000;

    uint8 maxPerTx = 2;
    uint8 maxTxPublic = 2;
    uint8 maxTxEarly = 1;

    uint256 public mintPrice = 1 ether;

    
    

    mapping(address => uint256) public purchaseTxs;

    event Purchased(uint256 indexed index, address indexed account, uint256 amount);

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _uri
        
    ) ERC1155(_uri)  {
        name_ = _name;
        symbol_ = _symbol;

    }

    /**
    * @notice edit the mint price
    *
    * @param _mintPrice the new price in wei
    */
    function setPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    
    
    

    /**
    * @notice purchase cards during public sale
    *
    * @param amount the amount of tokens to purchase
    */
    function purchase(uint256 amount) external payable whenNotPaused {
        require(purchaseTxs[msg.sender] < maxTxPublic , "max tx amount exceeded");

        _purchase(amount);

    }

    /**
    * @notice global purchase function used in early access and public sale
    *
    * @param amount the amount of tokens to purchase
    */
    function _purchase(uint256 amount) private {
        require(amount > 0 && amount <= maxPerTx, "Purchase: amount prohibited");
        require(totalSupply(0) + amount <= MAX_SUPPLY, "Purchase: Max supply reached");
        require(msg.value == amount * mintPrice, "Purchase: Incorrect payment");

        purchaseTxs[msg.sender] += 1;

        _mint(msg.sender, 0, amount, "");
        emit Purchased(0, msg.sender, amount);
    }

   
    /**
    * @notice returns the metadata uri for a given id
    *
    * @param _id the card id to return metadata for
    */
    function uri(uint256 _id) public view override returns (string memory) {
            require(exists(_id), "URI: nonexistent token");

            return string(abi.encodePacked(super.uri(_id), Strings.toString(_id)));
    }
}