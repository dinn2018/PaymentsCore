// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import "./IPaymentWithoutSwap.sol";
import "./IPaymentWithSwap.sol";

interface IPayment is IPaymentWithoutSwap, IPaymentWithSwap {

}