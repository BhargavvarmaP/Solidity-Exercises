//SPDX-License-Identifier:MIT
pragma solidity >=0.4.0 <0.9.0;
contract VotingPoll {
    
    struct Topic {
        uint256 topicid;
        string topic;
        Option[] options;
        uint256 expiry;
    }
    
    struct Option {
        string option;
        uint256 count;
    }
    
    struct Voter {
    address voter;
    }

    mapping(address=>mapping(uint256=>Topic)) public topiclist;
    mapping(address=>mapping(uint256=>bool)) public topicvalidator;
    mapping(address=>mapping(uint256=>bool)) public creatorvalidator;
    mapping(address=>Voter) public voterlist;
    mapping(address=>mapping(address=>mapping(uint256=>bool))) public votevalidator;
    mapping(address=>mapping(uint256=>mapping(address=>bool))) public votervalidator;
    mapping(uint256=>Option) public optionlist;

    modifier resetcount(uint256 _id,address _addr) {
        if(topiclist[_addr][_id].expiry>=block.timestamp){
            for(uint256 i=0;i<topiclist[_addr][_id].options.length;i++){
            topiclist[_addr][_id].options[i].count=0;
            }
        }
        _;
    }

    function createTopic(uint256 _topicid,string calldata _topic,uint256 _expirytime) public {
        require(topicvalidator[msg.sender][_topicid]==false,"Topic Already exists");
        _expirytime*=1 hours;
        topiclist[msg.sender][_topicid].topicid=_topicid;
        topiclist[msg.sender][_topicid].topic=_topic;
        topiclist[msg.sender][_topicid].expiry=block.timestamp+_expirytime;
        topicvalidator[msg.sender][_topicid]=true;
        creatorvalidator[msg.sender][_topicid]=true;
    }

    function createOption(uint256 _topicid,string calldata _option) public {
        require(topicvalidator[msg.sender][_topicid]==true,"Topic doesnt exist");
        require(topiclist[msg.sender][_topicid].options.length<3,"Only 3 options Allowed");
        topiclist[msg.sender][_topicid].options.push(Option(_option,0));
    }
   
    function Register() public {
        require(voterlist[msg.sender].voter==address(0),"Voter already registered");
        voterlist[msg.sender].voter=msg.sender;
    }
    function getTopic(uint256 _topicid,address _creator) public view returns(Topic memory) {
        return topiclist[_creator][_topicid];
    }

    function Vote(uint256 _topicid,address _creator,uint8 _option) public  {
        require(topicvalidator[_creator][_topicid]==true,"Topic doesnt exist");
        require(block.timestamp<topiclist[_creator][_topicid].expiry,"Voting ended");
        require(msg.sender==voterlist[msg.sender].voter,"Not a Registered Voter");
        require(votervalidator[_creator][_topicid][msg.sender]==true,"Topic Creator rejected you");
        require(votevalidator[msg.sender][_creator][_topicid]==false,"Already voted");
        require(_option<3,"Invalid Option");
             topiclist[_creator][_topicid].options[_option].count++;
             votevalidator[msg.sender][_creator][_topicid]=true;
    }

    function PermissionVoter(address _voter,uint256 _topicid,bool _allow) public {
        require(creatorvalidator[msg.sender][_topicid]==true,"Not a Topic Creator");
        require(_voter==voterlist[_voter].voter,"Not a Registered Voter");
        votervalidator[msg.sender][_topicid][_voter]=_allow;
    }
    function ResetCount(uint256 _topicid) public {
       require(creatorvalidator[msg.sender][_topicid]==true,"Not a Topic Creator"); 
        if(topiclist[msg.sender][_topicid].expiry>=block.timestamp){
            for(uint256 i=0;i<topiclist[msg.sender][_topicid].options.length;i++){
            topiclist[msg.sender][_topicid].options[i].count=0;
            }
        }
    }
}