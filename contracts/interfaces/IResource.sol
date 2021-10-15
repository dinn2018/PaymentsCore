// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

interface IResource {
	event Bought(address indexed buyer, uint256 amount, uint256 value);

	event Spent(address indexed buyer, uint256 amount);

	function buy(
		address buyer,
		uint256 amount,
		uint256 value,
		bytes memory data
	) external;

	function spend(address buyer, uint256 amount) external;

	function getValue(uint256 amount) external view returns (uint256);

	function getAmount(uint256 value) external view returns (uint256);

	/// @notice `valuationToken` is for resource price valuation and beneficiary.
	/// if you want use `ETH` to valuate your resource, set it `WETH`
	/// otherwise set it a ERC20 token address.
	function valuationToken() external view returns (address);

	function beneficiary() external view returns (address);
}
