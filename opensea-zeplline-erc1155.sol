// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BabuNFT is ERC1155 , Ownable {
    uint256 public constant GOLD = 0;
    uint256 public constant SILVER = 1;
    uint256 public constant THORS_HAMMER = 2;
    uint256 public constant SWORD = 3;
    uint256 public constant SHIELD = 4;

    constructor() ERC1155("https://abcoathup.github.io/SampleERC1155/api/token/{id}.json") {
        _mint(msg.sender, GOLD, 180, "");
        _mint(msg.sender, SILVER, 270, "");
        _mint(msg.sender, THORS_HAMMER, 10, "");
        _mint(msg.sender, SWORD, 90, "");
        _mint(msg.sender, SHIELD, 50, "");
    }


    function mint(address account, uint256 id , uint256 amount) public onlyOwner {
        _mint(account,id,amount,"");
    }

    function burn(address account, uint256 id , uint256 amount) public {
        require(msg.sender == account);
        _burn(account,id,amount);
    }

}