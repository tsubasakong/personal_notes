[Reddit discussion](https://www.reddit.com/r/ethdev/comments/qpg8td/airdropping_erc721_nft/)


code example
```solidity
bool public onlyWhitelisted = true;
address[] public whitelistedAddresses;  

function isWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < whitelistedAddresses.length; i++) {
      if (whitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
  }


    function claim(bytes32[] calldata merkleProof)
        external
        isValidMerkleProof(merkleProof, claimListMerkleRoot)
        canGiftWitches(1)
    {
        require(!claimed[msg.sender], "Witch already claimed by this wallet");

        claimed[msg.sender] = true;
        numGiftedWitches += 1;

        _safeMint(msg.sender, nextTokenId());
    }
```