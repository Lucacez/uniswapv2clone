// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/UniswapV2Factory.sol";
import "../src/UniswapV2Pair.sol";
import "../src/test/ERC20.sol";

contract UniswapV2FactoryTest is Test {
    ERC20 public erc1;
    ERC20 public erc2;

    UniswapV2Factory public factoryTest;
    UniswapV2Pair public pairTest;
    address public pairDireccion;

    address public admin = address(0x1);
    address public alice = address(0x2);
    address public bob = address(0x3);

    function setUp() public {
        vm.startPrank(admin);
        erc1 = new ERC20(10000);
        erc2 = new ERC20(10000);
        factoryTest = new UniswapV2Factory(address(bob));
        vm.stopPrank();
    }

    function testCreatePair() public {
        vm.prank(admin);
        pairDireccion = factoryTest.createPair(address(erc1), address(erc2));

        assertEq(pairDireccion, factoryTest.getPair(address(erc1), address(erc2)));
        assertEq(factoryTest.allPairs(0), pairDireccion);
    }
}