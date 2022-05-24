The contract includes the following functions:
[Chainlink vef tutorial youtube](https://www.youtube.com/watch?v=JqZWariqh5s)
`requestRandomWords()`: Takes your specified parameters and submits the request to the VRF coordinator contract.
`fulfillRandomWords()`: Receives random values and stores them with your contract (callback function from chainlink oracle)

Example for `requestRandomWords()`

```solidity

    function requestChainlinkVRF() external onlyOwner {
        require(!randomseedRequested, "Chainlink VRF already requested");
        require(
            LINK.balanceOf(address(this)) >= 2000000000000000000,
            "Insufficient LINK"
        );
        requestRandomness(keyHash, 2000000000000000000);
        randomseedRequested = true;
        emit RandomseedRequested(block.timestamp);
    }


```


Example for `fulfillRandomWords()`

```solidity
    // randomNuber is returned by chainlink operator
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
        internal
        override
    {
        if (randomNumber > 0) {
            seed = randomNumber;
            emit RandomseedFulfilmentSuccess(block.timestamp, requestId, seed);
        } else {
            seed = 1;
            emit RandomseedFulfilmentFail(block.timestamp, requestId);
        }
    }

```