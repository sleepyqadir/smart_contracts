// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract SimpleStorage{
    uint256 storageData;

    function set(uint data) public{
        storageData = data;
    }

    function get() public view returns (uint){
        return storageData;
    }
}