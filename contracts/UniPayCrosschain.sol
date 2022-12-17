//SPDX-License-identifier:MIT
pragma solidity >=0.4.0 <0.9.0;
/*This smart contract allows the sender to transfer a specified amount of tokens to the receiver through a payment channel. The channel can be opened and closed using the closeChannel function. To transfer tokens, the transfer function is called and the tokens are transferred using the Parity Bridge contract. An event is also emitted to notify of the transfer.

This is just one example of how a payment channel smart contract can be implemented using the Parity Bridge. There are many other ways to design and implement a payment channel, and you may want to consider adding additional features or functionality to your contract based on your specific needs.
*/
import "https://github.com/paritytech/parity-bridge/contracts/BridgeValidators.sol";

contract PaymentChannel {
    // Address of the Parity Bridge contract
    address bridgeAddress = 0xB452C3D2c2e6B5cEe8b1F23B7BDe9F9d9c8F1D4e;
    
    // Address of the sender
    address payable sender;
    
    // Address of the receiver
    address payable receiver;
    
    // Amount of tokens being transferred
    uint256 amount;
    
    // Flag to indicate if the channel is open or closed
    bool channelOpen;
    
    // Event to notify of a transfer
    event Transfer(address indexed sender, address indexed receiver, uint256 amount);
    
    constructor(address _sender, address _receiver, uint256 _amount) public {
        sender = _sender;
        receiver = _receiver;
        amount = _amount;
        channelOpen = true;
    }
    
    function closeChannel() public {
        channelOpen = false;
    }
    
    function transfer(address _receiver, uint256 _amount) public {
        require(channelOpen, "Channel is closed");
        require(_receiver != address(0), "Invalid receiver address");
        require(_amount > 0, "Invalid amount");
        
        // Use the Parity Bridge to transfer the tokens to the receiver
        BridgeValidators bridge = BridgeValidators(bridgeAddress);
        bridge.transferFrom(sender, _receiver, _amount);
        
        // Emit the Transfer event
        emit Transfer(sender, _receiver, _amount);
    }
}
