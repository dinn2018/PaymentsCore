// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';

import '../interfaces/IResource.sol';
import '../access/Permitable.sol';

contract SimpleResourceERC20 is Permitable, IResource {
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
		IERC20 _valuationToken,
		uint256 _price,
		address _beneficiary
	) {
		valuationToken = address(_valuationToken);
		price = _price;
		// will receive `token` to current contract
		beneficiary = _beneficiary;
		transferOwnership(owner);
	}

	function spend(address buyer, uint256 amount) external override onlyPermit {
		require(balances[buyer] >= amount, 'Resource: not enough resources to spend.');
		balances[buyer] = balances[buyer].sub(amount);
		emit Spent(buyer, amount);
	}

	function buy(
		address buyer,
		uint256 amount,
		uint256 value
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
