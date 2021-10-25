// SPDX-License-Identifier: UNLICENSE

pragma solidity >=0.8.0;

import './IPaymentWithoutSwap.sol';
import './IPaymentWithSwap.sol';

interface IPayment is IPaymentWithoutSwap, IPaymentWithSwap {}
