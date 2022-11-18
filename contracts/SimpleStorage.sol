//SPDX-License-Identifier:MIT
pragma solidity >=0.4.0 <0.9.0;
contract SimpleStorage {
    uint256 public data;

    constructor() {
        data=0;
    }
    function setdata(uint256 _data) public {
        data=_data;
    }
    function getdata() public view returns(uint256) {
        return data;
    }
} 