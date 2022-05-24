Two royalties set method:
1. Specific to [Opensea](https://docs.opensea.io/docs/10-setting-fees-on-secondary-sales)
2. Through [contract (ERC2981)](https://github.com/alxrnz2/ERC1155-with-EIP2981-for-OpenSea#eip-2981-royalties)

Code example from [invisible friends contract](https://etherscan.io/address/0x59468516a8259058bad1ca5f8f4bff190d30e066#code)

```solidity
import { IERC2981, IERC165 } from "@openzeppelin/contracts/interfaces/IERC2981.sol";

  // ERC165
  /* frank: This function signals the contract is compatible with EIP 2981, in addition to ERC 1155 and ERC 165 (via the super call).
  */

  function supportsInterface(bytes4 interfaceId) public view override(ERC721, IERC165) returns (bool) {
    return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
  }

  // IERC2981

  function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address, uint256 royaltyAmount) {
    _tokenId; // silence solc warning
    royaltyAmount = (_salePrice / 100) * 5;
    return (royalties, royaltyAmount);
  }


```

Additional:
- [Solidity Inheritance](https://www.youtube.com/watch?v=Q5_Gmm_IZSI)
