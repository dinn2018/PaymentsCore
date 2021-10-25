// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0;

interface IRootChannel {
	function setChildChannel(address _childChannel) external;

	function sendMessageToChild(bytes memory message) external;

	function receiveMessage(bytes memory inputData) external;
}
