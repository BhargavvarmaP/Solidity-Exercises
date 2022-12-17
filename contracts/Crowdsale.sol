pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

contract CrowdsaleToken {
  using SafeMath for uint256;
  using SafeERC20 for ERC20;

  // Token symbol and name
  string public constant symbol = "TOKEN";
  string public constant name = "Crowdsale Token";

  // Total supply of the token
  uint256 public totalSupply;

  // Mapping from investor address to the number of tokens they own
  mapping(address => uint256) public investorTokens;

  // Current rate of the token in wei per token
  uint256 public rate;

  // Minimum contribution amount in wei
  uint256 public minContribution;

  // Maximum contribution amount in wei
  uint256 public maxContribution;

  // Timestamp of the start of the crowdsale
  uint256 public startTime;

  // Timestamp of the end of the crowdsale
  uint256 public endTime;

  // Flag to indicate if the crowdsale is active
  bool public crowdsaleActive;

  // Event that is emitted when a purchase is made
  event Purchase(address indexed investor, uint256 value, uint256 tokens);

  // Event that is emitted when the crowdsale is ended
  event CrowdsaleEnded();

  constructor(uint256 _totalSupply, uint256 _rate, uint256 _minContribution, uint256 _maxContribution, uint256 _startTime, uint256 _endTime) public {
    totalSupply = _totalSupply;
    rate = _rate;
    minContribution = _minContribution;
    maxContribution = _maxContribution;
    startTime = _startTime;
    endTime = _endTime;
    crowdsaleActive = true;
  }

  // Fallback function that is called when the contract receives ether
  function() external payable {
    // Check if the crowdsale is active and the received ether is within the allowed range
    require(crowdsaleActive, "Crowdsale is not active");
    require(msg.value.gte(minContribution) && msg.value.lte(maxContribution), "Ether value is not within the allowed range");

    // Calculate the number of tokens that can be purchased with the received ether
    uint256 tokens = msg.value.mul(rate).div(1 ether);

    // Update the investor's token balance
    investorTokens[msg.sender] = investorTokens[msg.sender].add(tokens);

    // Emit the Purchase event
    emit Purchase(msg.sender, msg.value, tokens);
  }

  // Function to end the crowdsale
  function endCrowdsale() public {
    // Check if the caller is the contract owner
    require(msg.sender == owner(), "Caller is not the contract owner");

    // Set the crowdsaleActive flag to false
    crowdsaleActive = false;

    // Emit the CrowdsaleEnded event
    emit CrowdsaleEnded();
  }
