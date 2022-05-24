
## Learn from 3Landers contract
import from `openzeppelin` lib
```solidity
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";

```

```solidity
 // frank: https://docs.openzeppelin.com/contracts/2.x/api/payment
    PaymentSplitter private _splitter;
```

```solidity
    struct revenueShareParams {
        address[] payees;
        uint256[] shares;
    }

```

revenueShareParams assigned values in initialize the contract
```solidity
constructor(
        uint256 _privateSalePrice,
        uint256 _publicSalePrice,
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
        chainlinkParams memory chainlink,
        revenueShareParams memory revenueShare // init the revenueshareParams
    )
```

set PaymentSplitter object
```solidity
        _splitter = new PaymentSplitter(
            revenueShare.payees,
            revenueShare.shares
        );
```

transfer the mint sales to the payment splitter contract in each mint transaction
```solidity

payable(_splitter).transfer(msg.value);
```

release payment to the split address
```solidity
    function release(address payable account) public virtual onlyOwner {
        _splitter.release(account);
    }
```