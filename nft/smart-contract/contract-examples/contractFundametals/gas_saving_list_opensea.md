
[Referece](https://github.com/ProjectOpenSea/opensea-erc1155)
> This contract overrides the isApprovedForAll method in order to whitelist the proxy accounts of OpenSea users. This means that they are automatically able to trade your ERC-1155 items on OpenSea (without having to pay gas for an additional approval). On OpenSea, each user has a "proxy" account that they control, and is ultimately called by the exchange contracts to trade their items.

> Note that this addition does not mean that OpenSea itself has access to the items, simply that the users can list them more easily if they wish to do so!

CryptoCoven example

```solidity
// These contract definitions are used to create a reference to the OpenSea
// ProxyRegistry contract by using the registry's address (see isApprovedForAll).
contract OwnableDelegateProxy {

}

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}

```