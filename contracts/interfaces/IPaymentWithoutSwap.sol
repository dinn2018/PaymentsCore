// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import "./IResource.sol";

interface IPaymentWithoutSwap {

    /// @notice buy token valuated resource directly with exact token amount.
    /// @param resource resource contract address.
    /// @param valueIn token in amount.
    /// @param amountOutMin resource min amount.
    /// @return amount resource amount for purchase.
    function buyTokenValuatedResourceByExactToken(
        IResource resource,
        uint256 valueIn,
        uint256 amountOutMin
    ) external returns (uint256 amount);

    /// @notice buy token valuated resource directly with exact resource amount.
    /// @param resource resource contract address.
    /// @param amountOut resource amount.
    /// @param valueInMax max value in.
    /// @return value token used for purchase.
    function buyExactTokenValuatedResourceByToken(
        IResource resource,
        uint256 amountOut,
        uint256 valueInMax
    ) external returns (uint256 value);

    /// @notice buy resource using `ETH` with exact eth value.
    /// @param resource resource contract address.
    /// @param amountOutMin resource min amount out.
    /// @return amount resource amount for purchase.
    function buyETHValuatedResourceByExactETH(
        IResource resource,
        uint256 amountOutMin
    ) external payable returns (uint256 amount);

    /// @notice buy resource using `ETH` with exact resource amount.
    /// @param resource resource contract address.
    /// @param amountOut resource min amount out.
    /// @return value `ETH` used for purchase.
    function buyExactETHValuatedResourceByETH(
        IResource resource,
        uint256 amountOut
    ) external payable returns (uint256 value);

}
