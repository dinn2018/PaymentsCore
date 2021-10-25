// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

import '../interfaces/IResource.sol';
import './ResourceWithChannel.sol';

contract StorageWithExpiration is ResourceWithChannel, IResource {
	struct Balance {
		uint256 total;
		uint256 left;
	}

	using SafeMath for uint256;

	using SafeERC20 for IERC20;

	// valuation for resource.
	address public override valuationToken;

	address public override beneficiary;

	uint256 public price;

	IUniswapV2Router02 public routerV2;

	address public buyBackReceiver;

	mapping(address => Balance) public balances;

	// For resource extral info
	mapping(uint256 => bytes) public slots;

	bytes4 public mintStorage = bytes4(keccak256('mintStorage(address,address,uint256,uint256)'));

	constructor(
		address owner,
		IRootChannel _channel,
		address _valuationToken,
		address _buyBackReceiver,
		IUniswapV2Router02 _routerV2,
		uint256 _price
	) ResourceWithChannel(_channel) {
		transferOwnership(owner);
		valuationToken = _valuationToken;
		buyBackReceiver = _buyBackReceiver;
		routerV2 = _routerV2;
		price = _price;
		beneficiary = address(this);
	}

	function buy(
		address buyer,
		uint256 amount,
		uint256 value,
		bytes memory data
	) external override onlyPermit {
		uint256 expiration = abi.decode(data, (uint256));
		balances[buyer].total = balances[buyer].total.add(amount);
		balances[buyer].left = balances[buyer].left.add(amount);
		sendMessageToChild(abi.encodeWithSelector(mintStorage, address(this), buyer, amount, expiration));
		emit Bought(buyer, amount, value);
	}

	function spend(address buyer, uint256 amount) external override onlyChannel {
		require(balances[buyer].left >= amount, 'StorageWithDeadline: not enough storage to spend.');
		balances[buyer].left = balances[buyer].left.sub(amount);
		emit Spent(buyer, amount);
	}

	function setPrice(uint256 _price) external onlyOwner {
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

	function transferBuyBackReceiver(address newReceiver) external onlyOwner {
		buyBackReceiver = newReceiver;
	}

	function buyBack(
		address[] memory path,
		uint256 value,
		uint256 amountOutMin,
		uint256 deadline
	) external onlyOwner {
		require(path.length > 1, 'StorageWithDeadline: path invalid.');
		IERC20(path[0]).safeApprove(address(routerV2), value);
		routerV2.swapExactTokensForTokens(value, amountOutMin, path, buyBackReceiver, deadline);
	}
}
