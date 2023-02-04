// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./UniswapV2Factory.t.sol";

contract UniswapV2PairTest is Test, UniswapV2FactoryTest {

    // function setUp() public {
    //     setUp();
    // }

    function testMint() public {
        testCreatePair();

        pairTest = UniswapV2Pair(pairDireccion);
        vm.startPrank(admin);
        erc1.transfer(pairDireccion, 5000);
        erc2.transfer(pairDireccion, 5000);
        vm.stopPrank();

        vm.prank(alice);
        pairTest.mint(address(alice));

        assertEq(4000, pairTest.balanceOf(address(alice)));
        assertEq(0, pairTest.balanceOf(address(admin)));
    }

    function testSwap() public {
        testMint();

        pairTest.reserve0();
        pairTest.reserve1();
        
        vm.startPrank(admin);
        erc1.transfer(pairDireccion, 1300);
        pairTest.swap(0, 1000, address(admin), new bytes(0));
        vm.stopPrank();

        assertEq(6000, erc2.balanceOf(address(admin)));
        assertEq(3700, erc1.balanceOf(address(admin)));

        vm.startPrank(admin);
        erc1.transfer(pairDireccion, 2300);
        pairTest.swap(0, 1000, address(admin), new bytes(0));
        vm.stopPrank();

        assertEq(7000, erc2.balanceOf(address(admin)));
        assertEq(1400, erc1.balanceOf(address(admin)));
    }

    function testBurn() public {
        testSwap();

        vm.startPrank(alice);
        pairTest.transfer(pairDireccion, 4000);
        pairTest.burn(address(alice));
        vm.stopPrank();

        assertEq(6880, erc1.balanceOf(address(alice)));
        assertEq(2400, erc2.balanceOf(address(alice)));
    }

    
}