// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "./MultiSigWallet.sol";

contract MultiSigTest is Test {
    MultiSigWallet public wallet;
    address[] public owners;
    address public owner1 = address(0x1);
    address public owner2 = address(0x2);
    address public receiver = address(0x3);

    function setUp() public {
        owners.push(owner1);
        owners.push(owner2);
        wallet = new MultiSigWallet(owners, 2);
        vm.deal(address(wallet), 10 ether);
    }

    function testSubmitAndConfirm() public {
        vm.prank(owner1);
        wallet.submitTransaction(receiver, 1 ether, "");
        
        vm.prank(owner1);
        wallet.confirmTransaction(0);
        
        vm.prank(owner2);
        wallet.confirmTransaction(0);
        
        (,,,bool executed, uint256 confirmations) = wallet.transactions(0);
        assertEq(confirmations, 2);
        assertEq(executed, false);
    }
}
