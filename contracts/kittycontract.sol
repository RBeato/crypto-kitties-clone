// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC721.sol";

abstract contract Kittycontract is IERC721{

    string public constant _tokenName = "CryptoKitties";
    string public constant _tokenSymbol = "CK";

    struct Kitty{
        uint256 genes;
        uint birthTime;
        uint mumId;
        uint dadId;
        uint generation;
    }

    Kitty[] kitties;

    mapping(address => uint256) ownershipTokenCount;
    mapping(uint256 => address) public kittyindexToOwner;
        

    function balanceOf(address owner) external view override returns (uint256 balance){
        return ownershipTokenCount[owner];
    }

    function totalSupply() public view override returns (uint256 total){
        return kitties.length;
    }


    function ownerOf(uint256 tokenId) external view override returns (address){
        return kittyindexToOwner[tokenId];
    }

    function transfer(address _to, uint256 _tokenId) external override {
        require(_to != address(0), "Cannot send tokens to this address");
        require(ownershipTokenCount[msg.sender]>0, "Not enough tokens");
        require(kittyindexToOwner[_tokenId]==msg.sender, "You must own the token");
    
        _transfer(msg.sender, _to, _tokenId);
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal {

        ownershipTokenCount[_to]++;
        kittyindexToOwner[_tokenId] = _to;
        
        if(_from !=address(0)){
        ownershipTokenCount[_from]--;

        }
        emit Transfer(_from, _to, _tokenId);
    }




   

}