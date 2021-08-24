// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

import "../interfaces/IInternalSwapResource.sol";
import "./ResourceWithChannel.sol";

contract InternalSwapResourceERC20 is ResourceWithChannel, IInternalSwapResource {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;

    // valuation for resource.
    address public override valuationToken;

    address public override beneficiary;

    uint256 public override price;

    IUniswapV2Router02 public override routerV2;

    address public override swapToken;

    address public override swapTo;

    mapping(address => uint256) public override balances;

    // For resource extral info
    mapping(uint256 => bytes) public slots;

    bytes4 public childBuy = bytes4(keccak256("buy(address,address,uint256)"));

    constructor(
        IRootChannel _channel,
        address _valuationToken,
        address _swapToken,
        address _swapTo,
        IUniswapV2Router02 _routerV2,
        uint256 _price
    ) ResourceWithChannel(_channel) {
        valuationToken = _valuationToken;
        swapToken = _swapToken;
        swapTo = _swapTo;
        routerV2 = _routerV2;
        price = _price;
        beneficiary = address(this);
    }

    function buy(address buyer, uint256 amount, uint256 value) external override onlyPermit {
        balances[buyer] = balances[buyer].add(amount);
        IERC20(valuationToken).safeApprove(address(routerV2), value);
        routerV2.swapExactTokensForTokens(
            value,
            0,
            swapPath(),
            swapTo,
            block.timestamp.add(10)
        );
        sendMessageToChild(abi.encodeWithSelector(childBuy, address(this), buyer, amount));
        emit Bought(buyer, amount, value);
    }

    function spend(address buyer, uint256 amount) external override onlyChannel {
        require(balances[buyer] >= amount, "Resource: not enough resources to spend.");
        balances[buyer] = balances[buyer].sub(amount);
        emit Spent(buyer, amount);
    }

    function setPrice(uint256 _price) external override onlyOwner {
        price = _price;
    }

    function setSlot(uint256 key, bytes memory value) external onlyOwner {
        slots[key] = value;
    }

    function getValue(uint256 amount) external view override returns (uint256) {
        return amount.mul(price);
    }

    function getAmount(uint256 value) external view override returns (uint256) {
        return value.div(price);
    }

    function swapPath() public view returns (address[] memory path) {
        path = new address[](2);
        path[0] = address(valuationToken);
        path[1] = address(swapToken);
    }

}
