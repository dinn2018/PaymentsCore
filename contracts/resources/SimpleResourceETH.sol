// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

import '../interfaces/IResource.sol';
import '../access/Permitable.sol';

contract SimpleResourceETH is Permitable, IResource {
	using SafeMath for uint256;

	using SafeERC20 for IERC20;

	// valuation for resource.
	address public override valuationToken;

	// price for resource using `token`.
	uint256 public price;

	address public override beneficiary;

	mapping(address => uint256) public balances;

	// For resource extral info
	mapping(uint256 => bytes) public slots;

	constructor(
		address owner,
		address _WETH,
		uint256 _price,
		address _beneficiary
	) {
		transferOwnership(owner);
		valuationToken = _WETH;
		price = _price;
		beneficiary = _beneficiary;
	}

	function spend(address buyer, uint256 amount) external override onlyPermit {
		require(balances[buyer] >= amount, 'Resource: not enough resources to spend.');
		balances[buyer] = balances[buyer].sub(amount);
		emit Spent(buyer, amount);
	}

	function buy(
		address buyer,
		uint256 amount,
		uint256 value,
		bytes memory data
	) external override onlyPermit {
		balances[buyer] = balances[buyer].add(amount);
		emit Bought(buyer, amount, value);
	}

	function setSlot(uint256 key, bytes memory value) external onlyOwner {
		slots[key] = value;
	}

	function setPrice(uint256 _price) external onlyOwner {
		price = _price;
	}

	function getValue(uint256 amount) public view override returns (uint256) {
		return amount.mul(price);
	}

	function getAmount(uint256 value) public view override returns (uint256) {
		return value.div(price);
	}
}
