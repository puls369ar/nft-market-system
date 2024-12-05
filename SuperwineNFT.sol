// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SuperwineNFT is ERC721Enumerable,ERC721Royalty, Ownable {
   

    // mapping(uint256 => RoyaltyInfo) public royalties;
    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxMintAmount = 5;
    uint256 public maxSupply = 100000;

    event Minted(address indexed to, uint256 tokenId, string tokenURI);

    constructor(string memory _name, string memory _symbol, string memory _baseURI2Set, address _feeCollector, uint96 _royalty) ERC721(_name, _symbol) Ownable(msg.sender) {
        baseURI=_baseURI2Set;
        
        _setDefaultRoyalty(_feeCollector,_royalty);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;

    }

    function mint(address _to, uint256 _mintAmount) public payable {
            uint256 supply = totalSupply();
            // require(!paused);
            require(_mintAmount > 0);
            require(_mintAmount <= maxMintAmount);
            require(supply + _mintAmount <= maxSupply);
            
            
            for (uint256 i = 1; i <= _mintAmount; i++) {
                _safeMint(_to, supply + i);
            }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory) {
            // require(
                // _exists(tokenId),
                // "ERC721Metadata: URI query for nonexistent token"
                // );
                
                string memory currentBaseURI = _baseURI();
                return
                bytes(currentBaseURI).length > 0 
                ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
                : "";
    }


    // Below solving ERC721Enumaerable and ERC721Royalty name conflicts
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _increaseBalance(address account, uint128 amount)
        internal
        virtual
        override(ERC721Enumerable, ERC721)
    {
        ERC721Enumerable._increaseBalance(account, amount); // Call ERC721Enumerable implementation
        ERC721._increaseBalance(account, amount);   // Call ERC721Royalty implementation
    }

    // Override supportsInterface to include both ERC721Enumerable and ERC721Royalty
    
    
     function _update(address from, uint256 tokenId,address to)
        internal
        virtual
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        ERC721Enumerable._update(from, tokenId, to ); // Call ERC721Enumerable implementation
        return to;
    }
    

    // function royaltyInfo(uint256 tokenId) external view returns (address, uint256) {
    //     RoyaltyInfo memory info = royalties[tokenId];
    //     return (info.creator, info.percentage);
    // }
}
