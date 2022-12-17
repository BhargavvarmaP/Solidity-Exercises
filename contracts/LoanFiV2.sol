pragma solidity ^0.7.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeERC20.sol";

contract LendingPool {
    using SafeMath for uint;
    using SafeERC20 for ERC20;

    // Address of the ERC20 token contract
    ERC20 public collateralToken;

    // Address of the oracle contract that provides the ether price
    Oracle public etherPriceOracle;

    // Minimum collateralization ratio (in percent) required for a loan
    uint public minCollateralizationRatio;

    // Struct for a loan
    struct Loan {
        address borrower;
        uint etherAmount;
        uint collateralAmount;
        uint collateralizationRatio;
    }

    // Mapping from loan ID to loan struct
    mapping (uint => Loan) public loans;

    // Counter for generating unique loan IDs
    uint public loanCounter;

    // Event for when a loan is created
    event LoanCreated(uint loanId, address borrower, uint etherAmount, uint collateralAmount, uint collateralizationRatio);

    // Event for when a loan is closed
    event LoanClosed(uint loanId, address borrower, uint etherAmount, uint collateralAmount, uint collateralizationRatio);

    // Constructor for the LendingPool contract
    constructor(ERC20 _collateralToken, Oracle _etherPriceOracle, uint _minCollateralizationRatio) public {
        collateralToken = _collateralToken;
        etherPriceOracle = _etherPriceOracle;
        minCollateralizationRatio = _minCollateralizationRatio;
    }

    // Function to create a new loan
    function createLoan(uint etherAmount) public payable {
    // Check that the caller has approved the LendingPool contract to transfer the collateral tokens
    require(collateralToken.allowance(msg.sender, address(this)) >= etherAmount, "Collateral allowance insufficient.");

    // Check that the caller has sent enough ether to cover the loan fee
    require(msg.value >= etherAmount.mul(1 ether) / 1000, "Insufficient loan fee.");

    // Call the oracle to get the current ether price
    uint etherPrice = etherPriceOracle.getPrice();

    // Calculate the required collateral amount
    uint collateralAmount = etherAmount.mul(etherPrice).mul(100).div(minCollateralizationRatio);

    // Transfer the collateral tokens from the caller to the LendingPool contract
    require(collateralToken.transferFrom(msg.sender, address(this), collateralAmount), "Collateral transfer failed.");

    // Calculate the collateralization ratio
    uint collateralizationRatio = collateralAmount.mul(100).div(etherAmount.mul(etherPrice));

    // Create a new loan
    uint loanId = loanCounter++;
    loans[loanId] = Loan(msg.sender, etherAmount, collateralAmount, collateralizationRatio);

    // Transfer the ether to the borrower
    require(msg.sender.send(etherAmount.mul(1 ether)), "Ether transfer failed.");

    // Emit the LoanCreated event
    emit LoanCreated(loanId, msg.sender, etherAmount, collateralAmount, collateralizationRatio);
}
function repayLoan(uint loanId) public payable {
    // Get the loan
    Loan storage loan = loans[loanId];

    // Check that the borrower is the caller
    require(msg.sender == loan.borrower, "Only the borrower can repay the loan.");

    // Check that the borrower has sent enough ether to cover the loan repayment
    require(msg.value >= loan.etherAmount.mul(1 ether), "Insufficient repayment amount.");

    // Transfer the collateral tokens from the LendingPool contract back to the borrower
    require(collateralToken.transfer(loan.borrower, loan.collateralAmount), "Collateral transfer failed.");

    // Delete the loan from the mapping
    delete loans[loanId];

    // Emit the LoanClosed event
    emit LoanClosed(loanId, loan.borrower, loan.etherAmount, loan.collateralAmount, loan.collateralizationRatio);
}
function possessCollateral(uint loanId) public {
    // Get the loan
    Loan storage loan = loans[loanId];

    // Check that the borrower has defaulted on the loan
    require(now > loan.dueDate, "Borrower has not defaulted on the loan.");

    // Transfer the collateral tokens from the LendingPool contract to the contract owner
    require(collateralToken.transfer(owner, loan.collateralAmount), "Collateral transfer failed.");

    // Delete the loan from the mapping
    delete loans[loanId];

    // Emit the CollateralPossessed event
    emit CollateralPossessed(loanId, loan.borrower, loan.collateralAmount);
}
}