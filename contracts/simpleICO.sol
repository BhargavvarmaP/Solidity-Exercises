pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract ICO {
  using SafeMath for uint256;
  using SafeERC20 for ERC20;

  // Token symbol and name
  string public constant symbol = "CUSTOM";
  string public constant name = "Custom Token";

  // Initial price of the token in wei
  uint256 public constant initialPrice = 10000000000000000; // 0.01 ether

  // Total supply of the token
  uint256 public totalSupply;

  // Current balance of the contract
  uint256 public balance;

  // Mapping from investor address to the number of tokens they have purchased
  mapping(address => uint256) public investorTokens;

  // Event that is emitted when a purchase is made
  event Purchase(address indexed investor, uint256 value, uint256 tokens);

  constructor(uint256 _totalSupply) public {
    totalSupply = _totalSupply;
  }

  // Fallback function that is called when the contract receives ether
  function() external payable {
    // Calculate the number of tokens that can be purchased with the received ether
    uint256 tokens = msg.value.div(initialPrice);

    // Update the balance and the number of tokens owned by the investor
    balance = balance.add(msg.value);
    investorTokens[msg.sender] = investorTokens[msg.sender].add(tokens);

    // Emit the Purchase event
    emit Purchase(msg.sender, msg.value, tokens);
  }
}
