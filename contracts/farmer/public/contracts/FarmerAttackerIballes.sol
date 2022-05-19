//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Setup.sol";
import "hardhat/console.sol";

contract FarmerAttackerIballes{

    Setup private setup;
    CompDaiFarmer private farmer;
    CompFaucet private faucet;

    constructor(address _setup){
        setup = Setup(_setup);
        farmer = CompDaiFarmer(setup.farmer());
        faucet = CompFaucet(setup.faucet());
    }

    function attack() payable external{
        console.log(setup.DAI().balanceOf(address(farmer)));
        console.log(setup.COMP().balanceOf(address(farmer)));
        console.log(setup.COMP().balanceOf(address(faucet)));
        console.log(farmer.peekYield());
        console.log(setup.expectedBalance());
    }
}