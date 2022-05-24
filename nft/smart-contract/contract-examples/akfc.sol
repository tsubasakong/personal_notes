// File: contracts/ApeKidsFC.sol
contract ApeKidsFC is ERC721, Ownable {
  using Strings for uint256;
  using ECDSA for bytes32;
  //AKC contract
  IERC721Enumerable akcContract;
  //NFT params
  string public baseURI;
  string public defaultURI;
  string public mycontractURI;
  bool public finalizeBaseUri = false;
  uint256 private currentSupply;
  //mint parameters
  uint256 public maxSupply = 12626;
  uint256[] public stagePrice = [0, 0.1626 ether, 0.1626 ether, 0.0926 ether,0.0926 ether, 0.1626 ether];  //price for each stage
  uint256[] public stageLimit = [0, 2627, 2627, 12626, 12626, 12626];    //mint limit for each stage
  address public signer;        //WL signing key
  mapping(uint256 => bool) public akcClaimed;   //whether an AKC tokenId has been claimed
  mapping(uint8 => mapping(address => uint8)) public mint_count;  //mint_count[stage][addr]
  //withdraw
  address[] fundRecipients = [
    0x261D83Bb62b54B4eBEAe76195b13d190e292e22f, 
    0xe778d58088967D9F62874f493Dd374266Dba248D
    ];
  uint256[] receivePercentagePt = [4500, 5500];
  //state
  bool public paused = false;
  uint8 public stage = 0;
  //royalty
  address public royaltyAddr;
  uint256 public royaltyBasis;
  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    string memory _defaultURI,
    address _akc,
    address _signer,
    address _royaltyAddr, 
    uint256 _royaltyBasis
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    defaultURI = _defaultURI;
    akcContract = IERC721Enumerable(_akc);
    signer = _signer;
    royaltyAddr = _royaltyAddr;
    royaltyBasis = _royaltyBasis;
  }
  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
  // public
  function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
      return interfaceId == 0xe8a3d485 /* contractURI() */ ||
      interfaceId == 0x2a55205a /* ERC-2981 royaltyInfo() */ ||
      super.supportsInterface(interfaceId);
  }
  function ownedAKC(uint256[] memory _tokenIdsToClaim) public view returns (bool) {
    for (uint256 i; i < _tokenIdsToClaim.length; i++) {
      if(akcContract.ownerOf(_tokenIdsToClaim[i]) != msg.sender)
        return false;
    }    
    return true;
  }
  function mint(uint8 mint_num, uint256[] memory _tokenIdsToClaim, uint8 wl_max, bytes memory signature) public payable {
    require(!paused, "Contract paused");
    require((stage>0) && (stage<=5), "Invalid stage");
    uint256 supply = totalSupply();
    require(mint_num > 0,"at least 1 mint");
    require(supply + mint_num <= stageLimit[stage], "Hit stage limit");
    require(msg.value >= mint_num * stagePrice[stage], "Insufficient eth");
    require(supply + mint_num <= maxSupply, "max supply reached");
    if(stage==1){
      require(mint_num + mint_count[stage][msg.sender] <= wl_max, "Exceed WL limit");
      require(signature.length > 0, "Missing signature");
      require(checkSig(msg.sender, wl_max, signature), "Invalid signature");
      mint_count[stage][msg.sender] += mint_num;
    }else if(stage==2){
      require(signature.length > 0, "Missing signature");
      require(checkSig(msg.sender, wl_max, signature), "Invalid signture");
    }else if(stage==3){
      require(mint_num == _tokenIdsToClaim.length, "Mint more than claim");
      for(uint256 i;i<_tokenIdsToClaim.length;i++){
        require(akcContract.ownerOf(_tokenIdsToClaim[i]) == msg.sender, "Not owner of claim");
        require(akcClaimed[_tokenIdsToClaim[i]] == false, "Already claimed");
        akcClaimed[_tokenIdsToClaim[i]] = true;
      }
    }else if(stage==4){
      require(ownedAKC(_tokenIdsToClaim), "Not owned");
    }else if(stage==5){
    }
    currentSupply += mint_num;
    for (uint256 i = 1; i <= mint_num; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }
  function checkSig(address _addr, uint8 cnt, bytes memory signature) public view returns(bool){
    return signer == keccak256(abi.encodePacked('AKFC', _addr, cnt, stage)).recover(signature);
  }
  function tokensOfOwner(address _owner, uint startId, uint endId) external view returns(uint256[] memory ) {
    uint256 tokenCount = balanceOf(_owner);
    if (tokenCount == 0) {
        return new uint256[](0);
    } else {
        uint256[] memory result = new uint256[](tokenCount);
        uint256 index = 0;
        for (uint256 tokenId = startId; tokenId <= endId; tokenId++) {
            if (index == tokenCount) break;
            if (ownerOf(tokenId) == _owner) {
                result[index] = tokenId;
                index++;
            }
        }
        return result;
    }
  }
  function totalSupply() public view returns (uint256) {
    return currentSupply;
  }
  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
        : defaultURI;
  }
  function contractURI() public view returns (string memory) {
        return string(abi.encodePacked(mycontractURI));
  }
  //ERC-2981
  function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view 
  returns (address receiver, uint256 royaltyAmount){
    return (royaltyAddr, _salePrice * royaltyBasis / 10000);
  }
  //only owner functions ---
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    require(!finalizeBaseUri);
    baseURI = _newBaseURI;
  }
  function finalizeBaseURI() public onlyOwner {
    finalizeBaseUri = true;
  }
  function setContractURI(string memory _contractURI) public onlyOwner {
    mycontractURI = _contractURI;
    //return format based on https://docs.opensea.io/docs/contract-level-metadata
  }
  function setRoyalty(address _royaltyAddr, uint256 _royaltyBasis) public onlyOwner {
    royaltyAddr = _royaltyAddr;
    royaltyBasis = _royaltyBasis;
  }
  function nextStage() public onlyOwner {
    require(stage<5);
    stage++;
  }
  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  function reserveMint(uint256 _mintAmount, address _to) public onlyOwner {    
    uint256 supply = totalSupply();
    require(supply + _mintAmount <= maxSupply, "max supply reached");
    currentSupply += _mintAmount;
    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(_to, supply + i);
    }
  }
  //fund withdraw functions ---
  function withdrawFund() public onlyOwner {
    uint256 currentBal = address(this).balance;
    require(currentBal > 0);
    for (uint256 i = 0; i < fundRecipients.length-1; i++) {
      _withdraw(fundRecipients[i], currentBal * receivePercentagePt[i] / 10000);
    }
    //final address receives remainder to prevent ether dust
    _withdraw(fundRecipients[fundRecipients.length-1], address(this).balance);
  }
  function _withdraw(address _addr, uint256 _amt) private {
    (bool success,) = _addr.call{value: _amt}("");
    require(success, "Transfer failed");
  }
}