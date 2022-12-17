pragma solidity ^0.6.0;

import "https://github.com/paritytech/parity-bridge/contracts/BridgeValidators.sol";

contract PaymentChannel {
    // Address of the Parity Bridge contract
    address bridgeAddress = 0xB452C3D2c2e6B5cEe8b1F23B7BDe9F9d9c8F1D4e;
    
    // Address of the sender on the Ethereum chain
    address payable ethereumSender;
    
    // Address of the receiver on the Avalanche chain
    address avalancheReceiver;
    
    // Amount of tokens being transferred
    uint256 amount;
    
    // Flag to indicate if the channel is open or closed
    bool channelOpen;
    
    // Event to notify of a transfer
    event Transfer(address indexed ethereumSender, address indexed avalancheReceiver, uint256 amount);
    
    constructor(address _ethereumSender, address _avalancheReceiver, uint256 _amount) public {
        ethereumSender = _ethereumSender;
        avalancheReceiver = _avalancheReceiver;
        amount = _amount;
        channelOpen = true;
    }
    
    function closeChannel() public {
        channelOpen = false;
    }
    
    function transfer() public {
        require(channelOpen, "Channel is closed");
        require(avalancheReceiver != address(0), "Invalid receiver address");
        require(amount > 0, "Invalid amount");
        
        // Use the Parity Bridge to transfer the tokens from Ethereum to Avalanche
        BridgeValidators bridge = BridgeValidators(bridgeAddress);
        bridge.transferFrom(ethereumSender, avalancheReceiver, amount);
        
        // Emit the Transfer event
        emit Transfer(ethereumSender, avalancheReceiver, amount);
    }
}
