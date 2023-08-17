// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Vulnerable{
    bool lock = false;
    mapping (address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function callerAddress() public view returns(address,address){
        return (msg.sender,tx.origin);
    }

    

    // function withdraw() public{

    //     uint bal = balances[msg.sender];

    //     require(bal > 0);

    //     (bool sent, ) = msg.sender.call{value : bal}("");//balance transfer to msg.sender anf returns true/false according to transaction.
    //     require(sent,"Failed to send ether");

    //     balances[msg.sender] = 0;
    // }

    //solution for reentrancy attack : we create a bool flag initially false when anyone has called withdraw
    // then flag becomes true and remains till when all code inside withdraw do not get compiled so that the same 
    // person/or other do not call withdraw and then we again make flag false so that any other person can call withdraw; 
    function withdraw() public{
        
        require(lock==false,"Locked");
        lock = true;
        uint bal = balances[msg.sender];

        require(bal > 0);

        (bool sent, ) = msg.sender.call{value : bal}("");//balance transfer to msg.sender anf returns true/false according to transaction.
        require(sent,"Failed to send ether");

        balances[msg.sender] = 0;

        lock = false;
    }
}
