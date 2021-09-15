// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import '@openzeppelin/contracts/access/Ownable.sol';

abstract contract Permitable is Ownable {
	mapping(address => bool) public permits;

	function permit(address permitter, bool isPermit) public onlyOwner {
		permits[permitter] = isPermit;
	}

	modifier onlyPermit() {
		require(permits[msg.sender], 'Permitable: caller is not permitted.');
		_;
	}
}
