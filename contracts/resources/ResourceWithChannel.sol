// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import "../interfaces/IRootChannel.sol";
import "../access/Permitable.sol";

abstract contract ResourceWithChannel is Permitable {

    IRootChannel public channel;

    constructor(IRootChannel _channel) {
        channel = _channel;
    }

    function transferRootChannel(IRootChannel _channel) external onlyOwner {
        channel = _channel;
    }

    function sendMessageToChild(bytes memory message) internal  {
        channel.sendMessageToChild(message);
    }
    
    modifier onlyChannel() {
        require(msg.sender == address(channel), "ResourceWithChannel: Can be called by channel only.");
        _;
    }

}