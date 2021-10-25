// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0;

import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

import '../libraries/ResourceLibrary.sol';
import '../interfaces/IPaymentWithSwap.sol';
import './BasePayment.sol';

abstract contract PaymentWithSwap is BasePayment, IPaymentWithSwap {
	using ResourceLibrary for IResource;

	using SafeMath for uint256;

	using SafeERC20 for IERC20;

	function buyTokenValuatedResourceByOtherExactToken(
		IResource resource,
		address[] memory prePath,
		uint256 valueIn,
		uint256 amountOutMin,
		uint256 deadline,
		bytes memory data
	) external override returns (uint256 amount) {
		require(resource.safeValuationToken() != address(0), 'Payment: resource has no valuation token.');
		require(prePath.length > 0, 'Payment: empty pre path.');
		require(address(resource.safeValuationToken()) != WETH, 'Payment: resource valuated by ETH.');
		IERC20 tokenIn = IERC20(prePath[0]);
		tokenIn.safeTransferFrom(msg.sender, address(this), valueIn);
		tokenIn.safeApprove(address(routerV2), valueIn);
		uint256 valueOutMin = resource.safeGetValue(amountOutMin);
		uint256[] memory valuesOut = routerV2.swapExactTokensForTokens(valueIn, valueOutMin, path(resource, prePath), resource.safeBeneficiary(), deadline);
		uint256 valueOut = valuesOut[valuesOut.length - 1];
		amount = resource.safeGetAmount(valueOut);
		_buyAfter(resource, msg.sender, amount, valueOut, data);
	}

	function buyExactTokenValuatedResourceByOtherToken(
		IResource resource,
		address[] memory prePath,
		uint256 amountOut,
		uint256 valueInMax,
		uint256 deadline,
		bytes memory data
	) external override returns (uint256 value) {
		require(resource.safeValuationToken() != address(0), 'Payment: resource has no valuation token.');
		require(prePath.length > 0, 'Payment: empty pre path.');
		require(address(resource.safeValuationToken()) != WETH, 'Payment: resource valuated by ETH.');
		IERC20 tokenIn = IERC20(prePath[0]);
		uint256 valueOut = resource.safeGetValue(amountOut);
		tokenIn.safeTransferFrom(msg.sender, address(this), valueInMax);
		tokenIn.safeIncreaseAllowance(address(routerV2), valueInMax);
		uint256[] memory valuesIn = routerV2.swapTokensForExactTokens(valueOut, valueInMax, path(resource, prePath), resource.safeBeneficiary(), deadline);
		// refund to user.
		value = valuesIn[0];
		if (value < valueInMax) {
			uint256 left = valueInMax.sub(value);
			tokenIn.safeTransfer(msg.sender, left);
			tokenIn.safeDecreaseAllowance(address(routerV2), left);
		}

		_buyAfter(resource, msg.sender, amountOut, valueOut, data);
	}

	function buyTokenValuatedResourceByExactETH(
		IResource resource,
		address[] memory prePath,
		uint256 amountOutMin,
		uint256 deadline,
		bytes memory data
	) external payable override returns (uint256 amount) {
		require(resource.safeValuationToken() != address(0), 'Payment: resource has no valuation token.');
		require(prePath.length > 0, 'Payment: empty pre path.');
		require(prePath[0] == WETH, 'Payment: WETH not the first address in pre path.');
		address buyer = msg.sender;
		uint256 valueIn = msg.value;
		uint256 valueOutMin = resource.safeGetValue(amountOutMin);
		uint256[] memory valuesOut = routerV2.swapExactETHForTokens{ value: valueIn }(
			valueOutMin,
			path(resource, prePath),
			resource.safeBeneficiary(),
			deadline
		);
		uint256 valueOut = valuesOut[valuesOut.length - 1];
		amount = resource.safeGetAmount(valueOut);
		_buyAfter(resource, buyer, amount, valueOut, data);
	}

	function buyExactTokenValuatedResourceByETH(
		IResource resource,
		address[] memory prePath,
		uint256 amountOut,
		uint256 deadline,
		bytes memory data
	) external payable override returns (uint256 value) {
		require(resource.safeValuationToken() != address(0), 'Payment: resource has no valuation token.');
		require(prePath.length > 0, 'Payment: empty pre path.');
		require(prePath[0] == WETH, 'Payment: WETH not the first address in pre path.');
		address buyer = msg.sender;
		uint256 valueOut = resource.safeGetValue(amountOut);
		uint256[] memory valuesIn = routerV2.swapETHForExactTokens{ value: msg.value }(valueOut, path(resource, prePath), resource.safeBeneficiary(), deadline);
		value = valuesIn[0];
		if (msg.value > value) {
			// refund buyer.
			payable(buyer).transfer(msg.value.sub(value));
		}
		_buyAfter(resource, buyer, amountOut, valueOut, data);
	}

	function buyETHValuatedResourceByExactToken(
		IResource resource,
		address[] memory prePath,
		uint256 valueIn,
		uint256 amountOutMin,
		uint256 deadline,
		bytes memory data
	) external override returns (uint256 amount) {
		require(prePath.length > 0, 'Payment: empty pre path.');
		require(resource.safeValuationToken() == WETH, 'Payment: resource not valuated by WETH.');
		address tokenIn = prePath[0];
		IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), valueIn);
		IERC20(tokenIn).safeApprove(address(routerV2), valueIn);
		uint256 valueOutMin = resource.safeGetValue(amountOutMin);
		uint256[] memory valuesOut = routerV2.swapExactTokensForETH(valueIn, valueOutMin, path(resource, prePath), resource.safeBeneficiary(), deadline);
		uint256 valueOut = valuesOut[valuesOut.length - 1];
		amount = resource.safeGetAmount(valueOut);
		_buyAfter(resource, msg.sender, amount, valueOut, data);
	}

	function buyExactETHValuatedResourceByToken(
		IResource resource,
		address[] memory prePath,
		uint256 amountOut,
		uint256 valueInMax,
		uint256 deadline,
		bytes memory data
	) external override returns (uint256 value) {
		require(prePath.length > 0, 'Payment: empty pre path.');
		require(resource.safeValuationToken() == WETH, 'Payment: resource not valuated by WETH.');
		address tokenIn = prePath[0];
		IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), valueInMax);
		IERC20(tokenIn).safeIncreaseAllowance(address(routerV2), valueInMax);
		uint256 valueOut = resource.safeGetValue(amountOut);
		uint256[] memory valuesIn = routerV2.swapTokensForExactETH(valueOut, valueInMax, path(resource, prePath), resource.safeBeneficiary(), deadline);
		value = valuesIn[0];
		if (valueInMax > value) {
			uint256 left = valueInMax.sub(value);
			IERC20(tokenIn).safeTransfer(msg.sender, left);
			IERC20(tokenIn).safeDecreaseAllowance(address(routerV2), left);
		}
		_buyAfter(resource, msg.sender, amountOut, valueOut, data);
	}

	function getAmountOut(
		IResource resource,
		address[] memory prePath,
		uint256 valueIn
	) public view override returns (uint256 amountOut) {
		return resource.getAmountOut(routerV2, valueIn, prePath);
	}

	function getValuesIn(
		IResource resource,
		address[] memory prePath,
		uint256 amountOut
	) public view override returns (uint256[] memory valuesIn) {
		return resource.getValuesIn(routerV2, amountOut, prePath);
	}

	function path(IResource resource, address[] memory prePath) public view override returns (address[] memory fullPath) {
		return resource.path(prePath);
	}
}
