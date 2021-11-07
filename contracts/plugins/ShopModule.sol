// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

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
    address _gameCore,
    string memory _metadataURL,
    address _donationRecipient
  ) ModuleBaseTemplate(_gameCore) ERC721("Badge", "BDG") {
    metadatUrl = _metadataURL;
    donationRecipient = _donationRecipient;
  }

  // In this example shop module, players can receive donations into a designated address in return
  // for a memorabilia NFT
  // NOTE: GameCore is inherited. Does this conflict with the storage unit?
  function donateEnergyTokens(uint256 _amount) public payable {
    require(IERC20(IGameStorage(gameCore).energyTokenAddress()).balanceOf(msg.sender) > _amount, "Insufficient tokens");
    IERC20(IGameStorage(gameCore).energyTokenAddress()).transferFrom(msg.sender, donationRecipient, _amount);
    tokenURIs[tokenId] = metadatUrl;
    _mint(msg.sender, tokenId);
    tokenId++;
  }

  function tokenURI(uint256 _tokenid) public view override returns (string memory) {
    return tokenURIs[_tokenid];
  }
}
