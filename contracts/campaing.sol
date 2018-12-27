pragma solidity ^0.4.25;
contract Campaing{
    
    struct Request{
        uint amount;
        string description;
        address recipient;
        bool complete;
        mapping( address => bool ) aproval;
        uint aprovalCount;
        uint deniedCount;
    }
    
    address public manager;
    uint public mininumContribuitor ;
    uint public balancedPendent;
    mapping( address => uint ) public approvers;
    address[] public approversAdresses;
    Request[] public requests;
    
    constructor( uint _mininumContribuitor ) public{
        manager = msg.sender;
        mininumContribuitor = _mininumContribuitor * 1 ether;
    }
    
    function contribute() public payable{
        require(manager != msg.sender,"no permitions");
        require(msg.value > mininumContribuitor,"mininum not reached");
        require(approvers[msg.sender] == 0,"already contribuited"); 
        
        approvers[msg.sender] = msg.value;
        approversAdresses.push(msg.sender);
        
    }
    
    function createRequest(uint _amount, string _description, address _recipient) public {
        require(manager == msg.sender, "no permitions");
        require(address(this).balance >= _amount * 1 ether + balancedPendent, "not enought money");
        
        Request memory newRequest = Request({
            amount: _amount * 1 ether,
            description: _description,
            recipient: _recipient,
            complete: false,
            aprovalCount: 0,
            deniedCount:0
        });
        balancedPendent += _amount * 1 ether;
        requests.push(newRequest);
            
    }
    
    function approveRequest(uint index, bool vote ) public  {
        require(approvers[msg.sender] != 0, "no contribuited"); 
        require(!requests[index].aproval[msg.sender], "already voted");
        requests[index].aproval[msg.sender] = true;
        if( vote == true ){
            requests[index].aprovalCount++;
        }else{
            requests[index].deniedCount++;
        }
        requests[index].complete = false;
        if(  (requests[index].aprovalCount+requests[index].deniedCount ) / 2 < requests[index].aprovalCount ){
            requests[index].complete = true; 
        }
    }
    
    function getBalanceFromContribuitor( address _address )public view returns( uint ) {
        return approvers[_address];
    }
    
    function finalizeRequest(uint index ) public {
        require(manager == msg.sender, "no permitions");
        require(requests[index].complete,"already finished");
        requests[index].recipient.transfer(address(this).balance);
        
    }
    
    function getBalance() public view returns( uint){
        return address(this).balance;
    }
    
}
