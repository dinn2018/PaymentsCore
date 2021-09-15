// SPDX-License-Identifier: MIT

pragma solidity >=0.7.3;

import './IResource.sol';

interface IPaymentWithSwap {

    /// @notice buy token valuated resource using other Token instead of resource valuated token.
    /// @param resource resource contract address.
    /// @param prePath pre path for exchange resource.
    /// for example  if prePath is [`tokenA`, `tokenB`, `tokenC`], 
    /// make sure [`tokenA`, `tokenB`, `tokenC` `resource.token()`] is existing in `IUniswapV2Router02`
    /// @param valueIn token in amount.
    /// @param amountOutMin resource min amount.
    /// @param deadline swap deadline.
    /// @return amount resource amount for purchase.
    function buyTokenValuatedResourceByOtherExactToken(
        IResource resource,
        address[] memory prePath,
        uint256 valueIn,
        uint256 amountOutMin,
        uint256 deadline
    ) external returns (uint256 amount);

    /// @notice buy exact token valuated resource using ERC20 Token.
    /// @param resource resource contract address.
    /// @param prePath pre path for exchange resource.
    /// for example  if prePath is [`tokenA`, `tokenB`, `tokenC`], 
    /// make sure [`tokenA`, `tokenB`, `tokenC` `resource.token()`] is existing in `IUniswapV2Router02`
    /// @param amountOut resource desired amount.
    /// @param valueInMax token max in amount.
    /// @param deadline swap deadline.
    /// @return value token used for purchase.
    function buyExactTokenValuatedResourceByOtherToken(
        IResource resource,
        address[] memory prePath,
        uint256 amountOut,
        uint256 valueInMax,
        uint256 deadline
    ) external returns (uint256 value);

    /// @notice buy resource using `ETH`, notice that your resource must be valuate by `WETH`.
    /// @param resource resource contract address.
    /// @param prePath pre path for exchange resource.
    /// for example  if prePath is [`tokenA`, `tokenB`, `tokenC`], 
    /// make sure [`tokenA`, `tokenB`, `tokenC` `resource.token()`] is existing in `IUniswapV2Router02`
    /// @param amountOutMin resource min amount.
    /// @param deadline swap deadline.
    /// @return amount resource amount for purchase.
    function buyTokenValuatedResourceByExactETH(
        IResource resource,
        address[] memory prePath,
        uint256 amountOutMin,
        uint256 deadline
    ) external payable returns (uint256 amount);

    /// @notice buy resource using `ETH` with exact resource amount,
    /// resource must be valuate by `WETH`.
    /// @param resource resource contract address.
    /// @param prePath pre path for exchange resource.
    /// for example  if prePath is [`tokenA`, `tokenB`, `tokenC`], 
    /// make sure [`tokenA`, `tokenB`, `tokenC` `resource.token()`] is existing in `IUniswapV2Router02`
    /// @param amountOut resource amount out.
    /// @param deadline swap deadline.
    /// @return value `ETH` used for purchase.
    function buyExactTokenValuatedResourceByETH(
        IResource resource,
        address[] memory prePath,
        uint256 amountOut,
        uint256 deadline
    ) external payable returns (uint256 value);

    /// @notice buy ETH valuated resource using token with exact token.
    /// @param resource resource contract address.
    /// @param prePath pre path for exchange resource.
    /// for example  if prePath is [`tokenA`, `tokenB`, `tokenC`], 
    /// make sure [`tokenA`, `tokenB`, `tokenC` `resource.token()`] is existing in `IUniswapV2Router02`
    /// @param valueIn exact token amount.
    /// @param amountOutMin resource min amount out.
    /// @param deadline swap deadline.
    /// @return amount resource amount for purchase.
    function buyETHValuatedResourceByExactToken(
        IResource resource,
        address[] memory prePath,
        uint256 valueIn,
        uint256 amountOutMin,
        uint256 deadline
    ) external returns (uint256 amount);

    /// @notice buy ETH valuated resource using token with exact resource amount.
    /// @param resource resource contract address.
    /// @param prePath pre path for exchange resource.
    /// for example  if prePath is [`tokenA`, `tokenB`, `tokenC`], 
    /// make sure [`tokenA`, `tokenB`, `tokenC` `resource.token()`] is existing in `IUniswapV2Router02`
    /// @param amountOut resource amount.
    /// @param valueInMax  token max value.
    /// @param deadline swap deadline.
    /// @return value token used for purchase.
    function buyExactETHValuatedResourceByToken(
        IResource resource,
        address[] memory prePath,
        uint256 amountOut,
        uint256 valueInMax,
        uint256 deadline
    ) external returns (uint256 value);

    function getAmountOut(
        IResource resource,
        address[] memory prePath,
        uint256 valueIn
    ) external view returns (uint256 amountOut);

    function getValuesIn(
        IResource resource,
        address[] memory prePath,
        uint256 amountOut
    ) external view returns (uint256[] memory valuesIn);

    function path(IResource resource, address[] memory prePath) external view returns (address[] memory fullPath);
}
