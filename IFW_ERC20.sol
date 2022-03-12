// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface IFW_ERC20{
    function burn(address ,uint256 ) external;
    function mint(address , uint256 ) external;
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}