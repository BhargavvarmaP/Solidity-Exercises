pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/SafeERC721.sol";

contract NFTPresale {
  using SafeMath for uint256;
  using SafeERC721 for ERC721;

  // Token symbol and name
  string public constant symbol = "NFT";
  string public constant name = "Non-Fungible Token";

  // Initial price of the token in wei
  uint256 public constant initialPrice = 100000000000000000; // 0.1 ether

  // Total supply of the token
  uint256 public totalSupply;

  // Mapping from token ID to token metadata
  mapping(uint256 => TokenMetadata) public tokens;

  // Mapping from investor address to the tokens they have purchased
  mapping(address => uint256[]) public investorTokens;

  // Event that is emitted when a purchase is made
  event Purchase(address indexed investor, uint256 tokenId, uint256 value);

  // Struct to store the metadata for each token
  struct TokenMetadata {
    string name;
    string imageUrl;
    string description;
  }

  constructor(uint256 _totalSupply) public {
    totalSupply = _totalSupply;
  }

  // Fallback function that is called when the contract receives ether
  function() external payable {
    // Check if the received ether is greater than or equal to the initial price
    require(msg.value.gte(initialPrice), "Ether value is not sufficient");

    // Generate a new token ID
    uint256 tokenId = totalSupply.add(1);

    // Update the total supply and the token metadata
    totalSupply = totalSupply.add(1);
    tokens[tokenId] = TokenMetadata("Token #" + tokenId, "", "");

    // Update the investor's token balance
    investorTokens[msg.sender].push(tokenId);

    // Emit the Purchase event
    emit Purchase(msg.sender, tokenId, msg.value);
  }

  // Function to update the metadata for a token
  function updateMetadata(uint256 tokenId, string memory _name, string memory _imageUrl, string memory _description) public {
    // Check if the caller owns the token
    require(ERC721.ownerOf(tokenId) == msg.sender, "Caller does not own the token");

    // Update the token metadata
    tokens[tokenId] = TokenMetadata(_name, _imageUrl, _description);
  }
}
