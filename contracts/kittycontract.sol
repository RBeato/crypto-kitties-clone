/// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Kittycontract is IERC721, Ownable{
    
    uint256 public constant CREATION_LIMIT_GEN0 = 10;
    string constant _tokenName = "CryptoKitties";
    string constant _tokenSymbol = "CK";

    event Birth(
           address owner,
        uint256 kittenId,
        uint256 mumId,
        uint256 dadId,
        uint256 genes);

    struct Kitty{
        uint256 genes;
         uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kitties;

    mapping(address => uint256) ownershipTokenCount;
    mapping(uint256 => address) public kittyindexToOwner;

    uint256 public gen0Counter;

    function createKittyGen0(uint256 _genes) public onlyOwner returns (uint256){
        require(gen0Counter < CREATION_LIMIT_GEN0);
        gen0Counter++;
        return _createKitty(0, 0, 0, _genes, msg.sender);
    }

    function _createKitty(
        uint256 _genes,
        uint256 _mumId,
        uint256 _dadId,
        uint256 _generation,
        address _owner
    ) private returns (uint256){
        Kitty memory _kitty = Kitty({
            genes: uint64(_genes),
            birthTime: uint64(block.timestamp),
            mumId: uint32(_mumId),
            dadId: uint32(_dadId),
            generation:  uint16(_generation)
        });
    
        kitties.push(_kitty);
       uint256 newKittenId = kitties.length - 1;

       emit Birth(_owner, newKittenId, _mumId, _dadId, _genes);

       _transfer(address(0), _owner, newKittenId);

       return newKittenId;
    }

    // function getKitty(uint256 kittyId) public view returns (uint256, uint64, uint32, uint32, uint16){
    //     return (
    //         kitties[kittyId].genes,
    //         kitties[kittyId].birthTime,
    //         kitties[kittyId].mumId, 
    //         kitties[kittyId].dadId,
    //         kitties[kittyId].generation
    //         );
    // }
    
    function getKitty(uint256 _id) external view returns(
        uint256 genes, 
        uint256 birthTime, 
        uint256 mumId, 
        uint256 dadId, 
        uint256 generation
        ){

        Kitty storage kitty = kitties[_id];

        birthTime = uint256(kitty.birthTime);
        mumId = uint256(kitty.mumId);
        dadId = uint256(kitty.dadId);
        generation = uint256(kitty.generation);
        genes = kitty.genes;
    }
        

    function balanceOf(address owner) external override view returns (uint256 balance){
        return ownershipTokenCount[owner];
    }

    function totalSupply() public override view  returns (uint256 total){
        return kitties.length;
    }

     function name() external override pure returns (string memory){return _tokenName;}

    function symbol() external override pure returns (string memory){return _tokenSymbol;}

    function ownerOf(uint256 tokenId) external view override returns (address){
        return kittyindexToOwner[tokenId];
    }

    function transfer(address _to, uint256 _tokenId) external override{
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