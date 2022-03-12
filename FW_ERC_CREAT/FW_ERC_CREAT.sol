// SPDX-License-Identifier: Z_NO
pragma solidity ^0.8.2;
import "./Farmer_ERC721.sol";
import "./Farmer_ERC20.sol";
contract FW_erc_creat{
    function NEW_ERC721(string memory name,string memory sym,string[] memory _states,uint256[] memory _value,string memory url,string memory url2)public returns(address a){
        bytes memory bytecode = type(Farmer_ERC721).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(url,msg.sender));
        assembly {
            a := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        Farmer_ERC721(a).base(name,sym,_states,_value,msg.sender,url,url2);
    }
    function NEW_ERC20(string memory name,string memory sym,string memory url)public returns(address a){
        bytes memory bytecode = type(Farmer_ERC20).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(url,msg.sender));
        assembly {
            a := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        Farmer_ERC20(a).base(name,sym,msg.sender,url);
    }
    function getcreationCode721() public pure returns (bytes32) {
        return keccak256(type(Farmer_ERC721).creationCode);
    }
    function getcreationCode20() public pure returns (bytes32) {
        return keccak256(type(Farmer_ERC20).creationCode);
    }
    
    
    // function createDSalted(string memory url) public {
    //     bytes32 salt = keccak256(abi.encodePacked(url,msg.sender));
    //     address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
    //         bytes1(0xff),
    //         address(this),
    //         salt,
    //         keccak256(abi.encodePacked(
    //             type(Farmer_ERC721).creationCode
    //         ))
    //     )))));
    //     Farmer_ERC721 d = new Farmer_ERC721{salt: salt}();
    //     require(address(d) == predictedAddress);
    // }
    
    // function createDSalted(string memory url,bytes32 creationCode) public {
    //     bytes32 salt = keccak256(abi.encodePacked(url,msg.sender));
    //     address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(
    //         bytes1(0xff),
    //         address(this),
    //         salt,
    //         hex'0x688ea48e8e83ff8d7ad09a7f1889b3a8cfee23921c720a939f7d4b2e32d3eccd'
    //     )))));
    //     Farmer_ERC721 d = new Farmer_ERC721{salt: salt}();
    //     require(address(d) == predictedAddress);
    // }
}