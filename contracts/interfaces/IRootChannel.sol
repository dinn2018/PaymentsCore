// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

interface IRootChannel {

    function setChildChannel(address _childChannel) external;

    function sendMessageToChild(bytes memory message) external;

    function receiveMessage(bytes memory inputData) external;

}
