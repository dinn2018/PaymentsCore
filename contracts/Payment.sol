// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

import './payments/PaymentWithoutSwap.sol';
import './payments/PaymentWithSwap.sol';
import './interfaces/IPayment.sol';

contract Payment is PaymentWithoutSwap, PaymentWithSwap, IPayment {

    constructor(IUniswapV2Router02 routerV2, address WETH) BasePayment(routerV2, WETH) {
    }

}
