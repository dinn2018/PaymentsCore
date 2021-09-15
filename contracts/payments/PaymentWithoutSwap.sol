// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';

import './BasePayment.sol';
import '../interfaces/IPaymentWithoutSwap.sol';
import '../libraries/ResourceLibrary.sol';

abstract contract PaymentWithoutSwap is BasePayment, IPaymentWithoutSwap {

    using ResourceLibrary for IResource;

    using SafeMath for uint256;
    
    using SafeERC20 for IERC20;

    function buyTokenValuatedResourceByExactToken(
        IResource resource,
        uint256 valueIn,
        uint256 amountOutMin
    ) external override returns (uint256 amount) {
        require(resource.safeValuationToken() != address(0), 'Payment: resource has no valuation token.');
        address buyer = msg.sender;
        amount = resource.safeGetAmount(valueIn);
        require(amount >= amountOutMin, 'Payment: insufficient value.');
        address token = resource.safeValuationToken();
        IERC20(token).safeTransferFrom(buyer, resource.safeBeneficiary(), valueIn);
        _buyAfter(resource, buyer, amount, valueIn);
    }

    function buyExactTokenValuatedResourceByToken(
        IResource resource,
        uint256 amountOut,
        uint256 valueInMax
    ) external override returns (uint256 value) {
        require(resource.safeValuationToken() != address(0), 'Payment: resource has no valuation token.');
        address buyer = msg.sender;
        address token = resource.safeValuationToken();
        value = resource.safeGetValue(amountOut);
        require(value <= valueInMax, 'Payment: insufficient value.');
        IERC20(token).safeTransferFrom(buyer, resource.safeBeneficiary(), value);
        _buyAfter(resource, buyer, amountOut, value);
    }

    function buyETHValuatedResourceByExactETH(
        IResource resource,
        uint256 amountOutMin
    ) external payable override returns (uint256 amount) {
        require(resource.safeValuationToken() == WETH, 'Payment: resource not valuated by ETH.');
        address buyer = msg.sender;
        uint256 valueIn = msg.value;
        amount = resource.safeGetAmount(valueIn);
        require(amount >= amountOutMin, 'Payment: insufficient value.');
        payable(resource.safeBeneficiary()).transfer(valueIn);
        _buyAfter(resource, buyer, amount, valueIn);
    }

    function buyExactETHValuatedResourceByETH(
        IResource resource,
        uint256 amountOut
    ) external payable override returns (uint256 value) {
        require(resource.safeValuationToken() == WETH, 'Payment: resource not valuated by ETH.');
        address buyer = msg.sender;
        value = resource.safeGetValue(amountOut);
        require(value <= msg.value, 'Payment: insufficient value.');
        payable(resource.safeBeneficiary()).transfer(value);
        if (value < msg.value) {
            payable(buyer).transfer(msg.value.sub(value));
        }
        _buyAfter(resource, buyer, amountOut, value);
    }
}