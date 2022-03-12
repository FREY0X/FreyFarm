// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
import "./IFW_ERC721.sol";
import "./IFW_ERC20.sol";
import "./IFW_ERC_CREAT.sol";
import "./Ownable.sol";
contract Farmersworld is Ownable {
    constructor(){
        FW_creat = 0xB5Fe8CbC1A636BA8dC101A5c75Eb51323E7a8899;//bnb
    }
    address FW_creat;
    struct token_info{
        address[] ERC20_Tokens;
        address[] ERC721_Tokens;
    }
    token_info token_infos;
    function view_token()view public returns(token_info memory){
        return token_infos;
    }
    function coin_creat(string memory name,string memory sym,string memory url)public onlyOwner {
        token_infos.ERC20_Tokens.push(IFW_ERC_CREAT(FW_creat).NEW_ERC20(name, sym,url));
    }
    function nft_creat(string memory name,string memory sym,string[] memory _states,uint256[] memory _value,string memory url,string memory url2)public onlyOwner{
        token_infos.ERC721_Tokens.push(IFW_ERC_CREAT(FW_creat).NEW_ERC721(name,sym,_states,_value,url,url2));
    }
    struct task_info{
        string name;
        uint cooldown;
        address[][] nft;//依次是查改增删
        string[][][] states;//依次是查改增
        uint[][][] change_code;//依次是大/小/等于
        uint[][][] values;
        address[][] token;//依次是增删
        uint[][] value;
    }
    task_info[][] task_infos;
    string[] private task_type;
    struct nft_task{
        uint type_id;
        uint task_id;
    }
    mapping(address=>nft_task[]) private nft_tasks;
    function nft_task_view(address nft)public view returns(nft_task[] memory){
        return nft_tasks[nft];
    }
    function task_type_creat(string memory name)public onlyOwner{
        task_infos.push();
        task_type.push(name);
    }
    function task_type_view()view public returns(string[]memory){
        return task_type;
    }
    function task_infos_view(uint256 type_id)view public returns(task_info[]memory){
        return task_infos[type_id];
    }
    function task_creat(uint256 type_id,string memory name,uint cooldown,address[][] memory nft,string[][][]memory states,uint[][][] memory change_code,uint[][][]memory values,address[][]memory token,uint[][]memory value)public onlyOwner{
        task_infos[type_id].push(task_info(name,cooldown,nft,states,change_code,values,token,value));
        for(uint256 i=0;i<nft[0].length;i++){
            nft_tasks[nft[0][i]].push(nft_task(type_id,task_infos[type_id].length-1));
        }
    }
    function task_do(uint256 type_id,uint256 id,uint[] memory check_tokenid)public{
        task_info memory n_task = task_infos[type_id][id];
        uint256 i;
        //查
        address n_add;
        uint256 n_tokenid;
        for(i=0;i<n_task.nft[0].length;i++){
            n_add=n_task.nft[0][i];
            n_tokenid=check_tokenid[i];
            require(IFW_ERC721(n_add).ownerOf(n_tokenid)==msg.sender,"This NFT doesn't belong to you");
            require(IFW_ERC721(n_add).token_info_view(n_tokenid,"cooldown")<=block.timestamp,"Skill cooling");
            uint256 ERC_value;
            uint256 value;
            uint256 change_code;
            //查
            uint256 j;
            if(n_task.states[0].length>i)
            for(j=0;j<n_task.states[0][i].length;j++){
                ERC_value=IFW_ERC721(n_add).token_info_view(n_tokenid,n_task.states[0][i][j]);
                value = n_task.values[0][i][j];
                change_code = n_task.change_code[0][i][j];
                if(change_code==0){
                    require(ERC_value>value,"NFT does not meet requirements 0");
                }else if(change_code==1){
                    require(ERC_value<value,"NFT does not meet requirements 1");
                }else{
                    require(ERC_value==value,"NFT does not meet requirements 2");
                }
            }
            //改
            IFW_ERC721(n_add).token_info_change(n_tokenid,"cooldown",n_task.cooldown+block.timestamp);
            if(n_task.states[1].length>i){
                for(j=0;j<n_task.states[1][i].length;j++){
                    ERC_value=IFW_ERC721(n_add).token_info_view(n_tokenid,n_task.states[1][i][j]);
                    value = n_task.values[1][i][j];
                    change_code = n_task.change_code[1][i][j];
                    if(change_code==0){
                        ERC_value-=value;
                    }else if(change_code==1){
                        ERC_value+=value;
                    }else if(change_code==2){
                        ERC_value=value;
                    }else {
                        ERC_value=uint256(keccak256(abi.encode(block.difficulty-i,blockhash(block.number-i))))%value;
                    }
                    n_task.values[1][i][j] = ERC_value;
                }
                IFW_ERC721(n_add).token_info_change(n_tokenid,n_task.states[1][i],n_task.values[1][i]);
            }
        }
        //增
        for(i=0;i<n_task.nft[1].length;i++){
            for(uint j=0;j<n_task.states[2][i].length;j++){
                if(n_task.change_code[2][i][j]==1){
                    n_task.values[2][i][j]=uint256(keccak256(abi.encode(block.difficulty-i,blockhash(block.number-i))))%n_task.values[2][i][j];
                }
            }
            IFW_ERC721(n_task.nft[1][i]).safeMint(msg.sender,n_task.states[2][i],n_task.values[2][i]);
        }
        //删nft
        for(i=0;i<n_task.value[2].length;i++)IFW_ERC721(n_task.nft[0][n_task.value[2][i]]).burn(check_tokenid[n_task.value[2][i]]);
        //增
        for(i=0;i<n_task.token[0].length;i++)IFW_ERC20(n_task.token[0][i]).mint(msg.sender,n_task.value[0][i]);
        //删
        for(i=0;i<n_task.token[1].length;i++)IFW_ERC20(n_task.token[1][i]).burn(msg.sender,n_task.value[1][i]);
    }
    function task_cancel(uint256 type_id,uint256 id)public onlyOwner{
        delete task_infos[type_id][id];
    }
}