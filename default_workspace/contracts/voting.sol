// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//contract 
contract voting{

    //vote details
    struct vote{
        address VoterAddress;
        bool choice;
    }

    //voter details
    struct voter{
        string VoterName;
        bool voted;
    }

    //counting variables
    uint private count = 0;
    uint public result = 0;
    uint public noVoter = 0;
    uint public noVote = 0;

    //variables for voter details
    address public voteradress;
    string public name;
    string public choicevoter;

    //mapping of number of vote
    mapping(uint => vote) private votes;
    //mapping of number of voters
    mapping(address => voter) public RegisterVoters;

    //defining states of our contract 
    enum State{Created,Voted,Ended}
    State public state;

    //conditions
    modifier conditon(bool _condition){
        require(_condition);
        _;
    }

    modifier onlyReg(){
        require(msg.sender == voteradress);
        _;
    }

    modifier inState(State _state){
        require(state == _state);
        _;
    }


    //basic functions

    constructor(
        string memory _votername,
        string memory _choice
    )  {
        voteradress = msg.sender;
        name = _votername;
        choicevoter = _choice;
        state = State.Created; 
    }

    function addVoter(
        address _voterAdd,
        string memory _name
    )public inState(State.Created) 
            onlyReg
    {
        voter memory vot;
        vot.VoterName = _name;
        vot.voted = false;
        RegisterVoters[_voterAdd] = vot;
        noVoter++;
    }

    function startVoting() public inState(State.Created) 
                                 onlyReg
    {
        state = State.Voted;
    }

    function doVote(bool _choice) public inState(State.Voted) returns (bool voted)
    {
        bool found = false;
        if(bytes(RegisterVoters[msg.sender].VoterName).length != 0 && RegisterVoters[msg.sender].voted == false){
            RegisterVoters[msg.sender].voted = true;
            vote memory vot;
            vot.VoterAddress = msg.sender;
            vot.choice = _choice;
            if(_choice){
                result++;
            }
            votes[noVote] = vot;
            noVote++;
            found = true;
        }

        return found;

    }

    function endVote() public inState(State.Voted) 
                                onlyReg
    {
        state = State.Ended;
        result = count;
    }

     


}