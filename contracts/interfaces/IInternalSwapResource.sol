// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0;

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

import './IResource.sol';

interface IInternalSwapResource is IResource {
	function setPrice(uint256 price_) external;

	function routerV2() external view returns (IUniswapV2Router02);

	function swapToken() external view returns (address);

	function price() external view returns (uint256);

	function swapReceiver() external view returns (address);
}
