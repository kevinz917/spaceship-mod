//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interface/IModuleList.sol";

contract Modules is Ownable, IModuleList {
  mapping(address => bool) public whitelistedModules;

  constructor() {
    transferOwnership(msg.sender);
  }

  function whitelist(address _module) public onlyOwner {
    whitelistedModules[_module] = true;
  }

  // check if user is whitelisted
  function isWhitelisted(address _module) public view override returns (bool) {
    return whitelistedModules[_module];
  }
}
