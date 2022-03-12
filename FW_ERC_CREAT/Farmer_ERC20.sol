// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./ERC20.sol";

contract Farmer_ERC20 is ERC20{
    address FW_creat;
    constructor(){
        FW_creat =msg.sender;
    }
    function base(string memory name,string memory sym,address sender,string memory url)public {
        require(FW_creat ==msg.sender,"base error");
        set_info(name, sym);
        tokenURI2 = url;
        setOwner(sender);
    }
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    function setOwner(address newOwner) private {
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    function burn(address account,uint256 amount) public onlyOwner {
        _burn(account, amount);
    }
    string public tokenURI2;
}