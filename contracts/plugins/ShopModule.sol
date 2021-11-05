//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ModuleBaseTemplate.sol";

// TODO: Add ship interface
contract ShopModule is ModuleBaseTemplate, ERC721 {
  string public metadatUrl;
  uint256 public tokenId;
  address public donationRecipient;
  mapping(uint256 => string) public tokenURIs;

  constructor(
    address _gameStorage,
    string memory _metadataURL,
    address _donationRecipient
  ) ModuleBaseTemplate(_gameStorage) ERC721("Badge", "BDG") {
    metadatUrl = _metadataURL;
    donationRecipient = _donationRecipient;
  }

  // In this example shop module, players can receive donations into a designated address in return
  // for a memorabilia NFT
  function donateEnergyTokens(uint256 _amount) public payable {
    require(IERC20(IGameStorage(gameStorage).energyTokenAddress()).balanceOf(msg.sender) > _amount, "Insufficient tokens");
    IERC20(IGameStorage(gameStorage).energyTokenAddress()).transferFrom(msg.sender, donationRecipient, _amount);
    tokenURIs[tokenId] = metadatUrl;
    _mint(msg.sender, tokenId);
    tokenId++;
  }

  function tokenURI(uint256 _tokenid) public view override returns (string memory) {
    return tokenURIs[_tokenid];
  }
}
