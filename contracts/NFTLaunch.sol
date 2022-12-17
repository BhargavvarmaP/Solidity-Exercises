pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";

contract NFTCollection {
  using SafeMath for uint256;
  using SafeERC721 for ERC721;

  // Token symbol and name
  string public constant symbol = "NFT";
  string public constant name = "Non-Fungible Token";

  // Total supply of the token
  uint256 public totalSupply;

  // Mapping from token ID to token metadata
  mapping(uint256 => TokenMetadata) public tokens;

  // Mapping from investor address to the tokens they own
  mapping(address => uint256[]) public investorTokens;

  // Event that is emitted when a token is minted
  event Mint(address indexed to, uint256 tokenId);

  // Struct to store the metadata for each token
  struct TokenMetadata {
    string name;
    string imageUrl;
    string description;
  }

  constructor(uint256 _totalSupply) public {
    totalSupply = _totalSupply;
  }

  // Function to mint a new token and assign it to an investor
  function mint(address _to, string memory _name, string memory _imageUrl, string memory _description) public {
    // Check if the total supply has not been reached
    require(totalSupply.add(1) <= totalSupply, "Total supply has been reached");

    // Generate a new token ID
    uint256 tokenId = totalSupply.add(1);

    // Update the total supply and the token metadata
    totalSupply = totalSupply.add(1);
    tokens[tokenId] = TokenMetadata(_name, _imageUrl, _description);

    // Update the investor's token balance and transfer the token to them
    investorTokens[_to].push(tokenId);
    ERC721.safeTransfer(_to, tokenId);

    // Emit the Mint event
    emit Mint(_to, tokenId);
  }

  // Function to update the metadata for a token
  function updateMetadata(uint256 tokenId, string memory _name, string memory _imageUrl, string memory _description) public {
    // Check if the caller owns the token
    require(ERC721.ownerOf(tokenId) == msg.sender, "Caller does not own the token");

    // Update the token metadata
    tokens[tokenId] = TokenMetadata(_name, _imageUrl, _description);
  }
}
