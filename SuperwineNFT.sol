pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SuperwineNFT is ERC721Enumerable, Ownable {
    struct RoyaltyInfo {
        address creator;
        uint256 percentage; // in basis points (e.g., 500 = 5%)
    }

    // mapping(uint256 => RoyaltyInfo) public royalties;
    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxMintAmount = 5;
    uint256 public maxSupply = 100000;

    event Minted(address indexed to, uint256 tokenId, string tokenURI);

    constructor(string memory _name, string memory _symbol, string memory _baseURI2Set) ERC721(_name, _symbol) Ownable(msg.sender) {
        baseURI=_baseURI2Set;
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

    

    // function royaltyInfo(uint256 tokenId) external view returns (address, uint256) {
    //     RoyaltyInfo memory info = royalties[tokenId];
    //     return (info.creator, info.percentage);
    // }
}
