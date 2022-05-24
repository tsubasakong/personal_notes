[how-to-have-the-contract-check-if-the-msg-sender-currently-owns-a-specific-token](https://ethereum.stackexchange.com/questions/95000/how-to-have-the-contract-check-if-the-msg-sender-currently-owns-a-specific-token)


```solidity
IERC721Enumerable token = IERC721Enumerable(0x12341234...)

uint count = token.balanceOf(user);
if (count > 0) {
    // User owns at least 1 index
}

```
(example of akfc contract)[https://etherscan.io/address/0xd45eb82de0f33d4d2261c46b03a6000dd2366480#code]

```solidity
  function ownedAKC(uint256[] memory _tokenIdsToClaim) public view returns (bool) {
    for (uint256 i; i < _tokenIdsToClaim.length; i++) {
      if(akcContract.ownerOf(_tokenIdsToClaim[i]) != msg.sender)
        return false;
    }    
    return true;
  }
```