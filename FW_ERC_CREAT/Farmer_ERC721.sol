// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "./ERC721.sol";
import "./Counters.sol";
contract Farmer_ERC721 is ERC721{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    
    address FW_creat;
    constructor(){
        FW_creat =msg.sender;
    }
    function base(string memory name,string memory sym,string[] memory _states,uint256[] memory _value,address sender,string memory url,string memory url2)public {
        require(FW_creat ==msg.sender,"base error");
        set_info(name, sym);
        baseURI = url;
        tokenURI2 = url2;
        setOwner(sender);
        _mint(address(0),0);
        _tokenIdCounter.increment();
        //工作状态，冷却时间
        token_info[0].push(0);
        states.push("state");
        state_uint["state"] = 0;
        token_info[0].push(block.timestamp);
        states.push("cooldown");
        state_uint["cooldown"] = 1;
        
        uint256 l = _states.length;
        for(uint256 i=0;i<l;i++){
            token_info[0].push(_value[i]);
            states.push(_states[i]);
            state_uint[_states[i]] = i+2;
        }
    }
    
    string private baseURI;
    string public tokenURI2;
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        tokenId;
        return baseURI;
    }
    mapping(uint256=>uint256[])private token_info;//根据tokenid查询信息
    mapping(string=>uint256)private state_uint;//查信息对应的信息id
    string[] private states;//查信息id对应的信息
    function token_info_view(uint256 id,string memory state)view public returns(uint256){
        return token_info[id][state_uint[state]];
    }
    function token_info_view(uint256 id)view public returns(uint256[]memory){
        return token_info[id];
    }
    function states_info()view public returns(string[] memory){
        return states;
    }
    function token_info_change(uint256 id,string[] memory state,uint256[] memory change)public onlyOwner{
        uint256 l=state.length;
        for(uint256 i=0;i<l;i++){
            token_info_change(id,state[i],change[i]);
        }
    }
    function token_info_change(uint256 id,string memory state,uint256 change)public onlyOwner{
        token_info[id][state_uint[state]] = change;
    }
    function safeMint(address to,string[]memory spe_states,uint[]memory spe_values) public onlyOwner {
        _safeMint(to, _tokenIdCounter.current());
        uint256 tokenid = _tokenIdCounter.current();
        token_info[tokenid] = token_info[0];
        token_info_change(tokenid,spe_states,spe_values);
        _tokenIdCounter.increment();
    }
    mapping(address=>mapping(uint256=>uint256)) public Backpack;
    mapping(address=>mapping(uint256=>uint256)) public Backpack_t;
    function _beforeTokenTransfer(address from,address to,uint256 tokenId) internal override{
        uint256 x = balanceOf[from];
        uint256 y = Backpack_t[from][tokenId];
        uint256 z = Backpack[from][x];
        if(x!=y){
            Backpack[from][y] = z;
            Backpack_t[from][z] = y;
            delete Backpack[from][x];
        }else{
            delete Backpack[from][y];
        }
        delete Backpack_t[from][tokenId];
        z = balanceOf[to]+1;
        Backpack_t[to][tokenId]=z;
        Backpack[to][z] = tokenId;
    }
    function burn(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
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
}