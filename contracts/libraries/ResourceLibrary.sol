// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';
import '../interfaces/IResource.sol';

library ResourceLibrary {
	function safeBuy(
		IResource resource,
		address buyer,
		uint256 amount,
		uint256 value
	) internal {
		(bool success, bytes memory data) = address(resource).call(
			abi.encodeWithSelector(resource.buy.selector, buyer, amount, value)
		);
		require(success && data.length == 0, 'Resource: `buy` failed.');
	}

	function safeSpend(
		IResource resource,
		address buyer,
		uint256 amount
	) internal {
		(bool success, bytes memory data) = address(resource).call(
			abi.encodeWithSelector(resource.spend.selector, buyer, amount)
		);
		require(success && data.length == 0, 'Resource: `spend` failed.');
	}

	function safeValuationToken(IResource resource)
		internal
		view
		returns (address)
	{
		(bool success, bytes memory data) = address(resource).staticcall(
			abi.encodeWithSelector(resource.valuationToken.selector)
		);
		require(
			success && data.length != 0,
			'Resource: call `valuationToken` failed.'
		);
		return abi.decode(data, (address));
	}

	function safeBeneficiary(IResource resource)
		internal
		view
		returns (address)
	{
		(bool success, bytes memory data) = address(resource).staticcall(
			abi.encodeWithSelector(resource.beneficiary.selector)
		);
		require(
			success && data.length != 0,
			'Resource: call `beneficiary` failed.'
		);
		return abi.decode(data, (address));
	}

	function safeGetAmount(IResource resource, uint256 value)
		internal
		view
		returns (uint256)
	{
		(bool success, bytes memory data) = address(resource).staticcall(
			abi.encodeWithSelector(resource.getAmount.selector, value)
		);
		require(
			success && data.length != 0,
			'Resource: call `amountOf` failed.'
		);
		return abi.decode(data, (uint256));
	}

	function safeGetValue(IResource resource, uint256 amount)
		internal
		view
		returns (uint256)
	{
		(bool success, bytes memory data) = address(resource).staticcall(
			abi.encodeWithSelector(resource.getValue.selector, amount)
		);
		require(
			success && data.length != 0,
			'Resource: call `valueOf` failed.'
		);
		return abi.decode(data, (uint256));
	}

	function getAmountOut(
		IResource resource,
		IUniswapV2Router02 routerV2,
		uint256 valueIn,
		address[] memory prePath
	) internal view returns (uint256 amountOut) {
		if (prePath.length == 0) {
			return safeGetAmount(resource, valueIn);
		}
		address[] memory path = path(resource, prePath);
		uint256[] memory valuesOut = routerV2.getAmountsOut(valueIn, path);
		amountOut = safeGetAmount(resource, valuesOut[valuesOut.length - 1]);
	}

	function getValuesIn(
		IResource resource,
		IUniswapV2Router02 routerV2,
		uint256 amountOut,
		address[] memory prePath
	) internal view returns (uint256[] memory valuesIn) {
		if (prePath.length == 0) {
			valuesIn = new uint256[](1);
			valuesIn[0] = safeGetValue(resource, amountOut);
			return valuesIn;
		}
		uint256 valueOut = safeGetValue(resource, amountOut);
		address[] memory path = path(resource, prePath);
		valuesIn = routerV2.getAmountsIn(valueOut, path);
	}

	function path(IResource resource, address[] memory prePath)
		internal
		view
		returns (address[] memory fullPath)
	{
		uint256 len = prePath.length;
		fullPath = new address[](len + 1);
		address valuationToken = safeValuationToken(resource);
		for (uint256 i = 0; i < len; i++) {
			require(
				prePath[i] != valuationToken,
				'Resource: valuationToken exsits in pre path.'
			);
			fullPath[i] = prePath[i];
		}
		fullPath[len] = valuationToken;
	}
}
