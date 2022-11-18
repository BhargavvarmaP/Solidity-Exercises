//SPDX-Liecense-Identifier:MIT
pragma solidity >=0.4.0 <0.9.0;
contract Contacts {
    address[] private contactslist;
    mapping(address=>uint256) private index;
    address private admin;
    uint256 private contacts;

    constructor() {
        admin=msg.sender;
    }
    modifier OnlyAdmin() {
        require(msg.sender==admin,"Not an Authorized User");
        _;
    }
    
    modifier nonZero(address _addr) {
        require(_addr!=address(0),"Entered zero address");
        _;
    }
    function AddContact(address _addr) public OnlyAdmin nonZero(_addr){
        require(index[_addr]==0,"contact already exists");
        contactslist.push(_addr);
        contacts=contactslist.length;
        index[_addr]=contacts;
    }
    function UpdateContact(address _addr,address _newaddr) public OnlyAdmin nonZero(_addr){
      AddContact(_newaddr);
      DeleteContact(_addr);
    }
    function DeleteContact(address _addr) public OnlyAdmin nonZero(_addr){
        uint256 id = index[_addr];
        require(index[_addr]>0,"contact doesnt exist");
        address temp = contactslist[contacts-1];
        contactslist[contacts-1]=contactslist[id-1];
        contactslist[id-1]=temp;
        contactslist.pop();
        index[temp]=id;
        contacts--;
        index[_addr]=0;
    }
}