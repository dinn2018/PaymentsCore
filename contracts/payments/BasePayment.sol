// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0;

import '../interfaces/IResource.sol';
import '../libraries/ResourceLibrary.sol';

abstract contract BasePayment {
	using ResourceLibrary for IResource;

	event Bought(IResource indexed resource, address indexed buyer, uint256 amount, uint256 value);

	event SpendRollUp(IResource indexed resource, address indexed buyer, uint256 amount);

	IUniswapV2Router02 public routerV2;

	address public WETH;

	constructor(IUniswapV2Router02 _routerV2, address _WETH) {
		routerV2 = _routerV2;
		WETH = _WETH;
	}

	function _buyAfter(
		IResource resource,
		address buyer,
		uint256 amount,
		uint256 value,
		bytes memory data
	) internal {
		resource.safeBuy(buyer, amount, value, data);
		emit Bought(resource, buyer, amount, value);
	}
}
