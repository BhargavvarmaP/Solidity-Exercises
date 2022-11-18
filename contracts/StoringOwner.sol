// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 <0.9.0;
contract StoringOwner {
    address public owner;
    constructor() {
        owner=msg.sender;
    }
}