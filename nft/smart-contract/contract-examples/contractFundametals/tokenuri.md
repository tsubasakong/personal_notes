example from 3landers
function `tokenURI` is required for [opensea](https://docs.opensea.io/docs/metadata-standards)


```solidity
    function getMetadata(uint256 tokenId) public view returns (string memory) {
        if (_msgSender() != owner()) {
            require(tokenId < totalSupply(), "Token not exists.");
        }

        if (!isRevealed()) return "default";

        uint256[] memory metadata = new uint256[](maxSupply+1);

        for (uint256 i = 1; i <= maxSupply; i += 1) {
            metadata[i] = i;
        }
        // frank: encode method https://medium.com/@libertylocked/what-are-abi-encoding-functions-in-solidity-0-4-24-c1a90b5ddce8 
        for (uint256 i = 2; i <= maxSupply; i += 1) {
            uint256 j = (uint256(keccak256(abi.encode(seed, i))) % (maxSupply)) + 1;

            // frank: why switch the hashed id ???? shuffle?
            if(j>=2 && j<= maxSupply) {
                (metadata[i], metadata[j]) = (metadata[j], metadata[i]);
            }
        }


        return Strings.toString(metadata[tokenId]);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(tokenId < totalSupply()+1, "Token not exist.");

        return
            isRevealed()
                ? string(
                    abi.encodePacked(
                        _tokenBaseURI,
                        getMetadata(tokenId),
                        ".json"
                    )
                )
                : _defaultURI;
    }

```