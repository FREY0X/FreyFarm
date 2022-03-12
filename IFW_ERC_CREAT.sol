// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
interface IFW_ERC_CREAT{
    function NEW_ERC721(string memory,string memory,string[] memory,uint256[] memory,string memory,string memory)external returns(address);
    // function NEW_ERC721(string memory,string memory,string[] memory,uint256[] memory,string memory)external returns(address);
    function NEW_ERC20(string memory,string memory,string memory)external returns(address);
    function getcreationCode721() external pure returns (bytes32);
    function getcreationCode20() external pure returns (bytes32);
}