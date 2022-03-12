// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IFW_ERC721{
    function ownerOf(uint256) external view returns (address);
    function token_info_view(uint256,string memory)view external returns(uint256);
    function token_info_view(uint256)view external returns(uint256[]memory);
    function token_info_change(uint256,string[] memory,uint256[] memory)external;
    function token_info_change(uint256,string memory,uint256)external;
    function safeMint(address,string[]memory,uint[]memory) external;
    function burn(uint256)external;
}