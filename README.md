# Payments for ethereum solidity smart contract

## INSTALL

```bash
yarn
```

## TEST

```
yarn test
```

## SCRIPTS

`yarn prepare`

As a standard lifecycle npm script, it is executed automatically upon install. It generate config file and typechain to get you started with type safe contract interactions
<br/><br/>

`yarn lint`, `yarn lint:fix`, `yarn format` and `yarn format:fix`

These will lint and format check your code. the `:fix` version will modifiy the files to match the requirement specified in `.eslintrc` and `.prettierrc.`
<br/><br/>

`yarn build`

These will compile your contracts
<br/><br/>

`yarn gas`

These will produce a gas report for function used in the tests
<br/><br/>

`yarn coverage`

These will produce a coverage report in the `coverage/` folder

<br/><br/>

`yarn dev`

These will run a local hardhat network on `localhost:8545` and deploy your contracts on it. Plus it will watch for any changes and redeploy them.
<br/><br/>

`yarn <network>:export`

This will export the abi+address of deployed contract to `<network>.json`
<br/><br/>

#### Contracts

- RootChannel

  ```
  用于主链与子链的state transfer
  ```

  | Functions          | Params                | Access   | Description                             |
  | ------------------ | --------------------- | -------- | --------------------------------------- |
  | setChildChannel    | address _childChannel | Owner    | 子链Channel contract地址                |
  | sendMessageToChild | bytes message         | Internal | 主链发送message至子链                   |
  | receiveMessage     | bytes proof           | Owner    | 接收子链的tx proof，以获得子链的message |
  
- IResource （Interface）

  | Functions      | Params                                             | Return  | Access           | Description                                  |
  | -------------- | -------------------------------------------------- | ------- | ---------------- | -------------------------------------------- |
  | buy            | address buyer<br/>uint256 amount<br/>uint256 value |         | Payment at least | 用户通过Payment购买时会由Payment调用         |
  | spend          | address from <br/>uint256 amount                   |         | Payment at least | 接收到子链消息时会调用                       |
  | getValue       | uint256 amount                                     | uint256 | Payment at least | 计算`amount` resource的价值                  |
  | getAmount      | uint256 value                                      | uint256 | Payment at least | 计算`value` resource的数量                   |
  | balances       | address from                                       |         |                  | 用户拥有的resource数量                       |
  | valuationToken |                                                    | address | Payment at least | resource 计价token,若使用ETH计价，则使用WETH |
  | beneficiary    |                                                    | address | Payment at least | token或ETH接收者                             |

- Payment

  ```
  用于用户支付
  ```

  ----

  ```
  function buyTokenValuatedResourceByExactToken(
          IResource resource,
          uint256 valueIn,
          uint256 amountOutMin
  ) external returns (uint256 amount)
  ```
  
  `params`
  
  | Name           | Type        | Description                    |
  | -------------- | ----------- | ------------------------------ |
  | `resource`     | `IResource` | resource contract address      |
  | `valueIn`      | `uint256`   | amount token to buy            |
  | `amountOutMin` | `uint256`   | minimum amount resource to buy |
  
  `returns`
  
  | Name     | Type      | Description         |
  | -------- | --------- | ------------------- |
  | `amount` | `uint256` | amount resource got |
  
  ----
  
  ```
  function buyExactTokenValuatedResourceByToken(
          IResource resource,
          uint256 amountOut,
          uint256 valueInMax
  ) external returns (uint256 value)
  ```
  
  `params`
  
  | Name         | Type        | Description                 |
  | ------------ | ----------- | --------------------------- |
  | `resource`   | `IResource` | resource contract address   |
  | `amountOut`  | `uint256`   | amount resource to buy      |
  | `valueInMax` | `uint256`   | maximum amount token to buy |
  
  `returns`
  
  | Name    | Type      | Description                                    |
  | ------- | --------- | ---------------------------------------------- |
  | `value` | `uint256` | amount token used to buy `amountOut` resource. |
  
  -----
  
  ```
  function buyETHValuatedResourceByExactETH(
          IResource resource,
          uint256 amountOutMin
  ) external payable returns (uint256 amount)
  ```
  
  `params`
  
  | Name           | Type        | Description                    |
  | -------------- | ----------- | ------------------------------ |
  | `resource`     | `IResource` | resource contract address      |
  | `amountOutMin` | `uint256`   | minimum amount resource to buy |
  
  `returns`
  
  | Name     | Type      | Description         |
  | -------- | --------- | ------------------- |
  | `amount` | `uint256` | amount resource got |
  
  ----
  
  ```
  function buyExactETHValuatedResourceByETH(
          IResource resource,
          uint256 amountOut
  ) external payable returns (uint256 value)
  ```
  
  `params`
  
  | Name        | Type        | Description               |
  | ----------- | ----------- | ------------------------- |
  | `resource`  | `IResource` | resource contract address |
  | `amountOut` | `uint256`   | amount resource to buy    |
  
  `returns`
  
  | Name    | Type      | Description                                    |
  | ------- | --------- | ---------------------------------------------- |
  | `value` | `uint256` | amount token used to buy `amountOut` resource. |
  
  ----
  
  ```
  function buyTokenValuatedResourceByOtherExactToken(
          IResource resource,
          address[] memory prePath,
          uint256 valueIn,
          uint256 amountOutMin,
          uint256 deadline
  ) external returns (uint256 amount)
  ```
  
  `params`
  
  | Name           | Type        | Description                                               |
  | -------------- | ----------- | --------------------------------------------------------- |
  | `resource`     | `IResource` | resource contract address                                 |
  | `prePath`      | `address[]` | pre path to resource `valuationToken`                     |
  | `valueIn`      | `uint256`   | amount token to buy                                       |
  | `amountOutMin` | `uint256`   | minimum amount resource to buy                            |
  | `deadline`     | `uint256`   | Deadlint to buy, should be greater than `block.timestamp` |
  
  `returns`
  
  | Name     | Type      | Description         |
  | -------- | --------- | ------------------- |
  | `amount` | `uint256` | amount resource got |
  
  -----
  
  ```
  function buyExactTokenValuatedResourceByOtherToken(
          IResource resource,
          address[] memory prePath,
          uint256 amountOut,
          uint256 valueInMax,
          uint256 deadline
  ) external returns (uint256 value)
  ```
  
  `params`
  
  | Name         | Type        | Description                                               |
  | ------------ | ----------- | --------------------------------------------------------- |
  | `resource`   | `IResource` | resource contract address                                 |
  | `prePath`    | `address[]` | pre path to resource `valuationToken`                     |
  | `amountOut`  | `uint256`   | amount resource to buy                                    |
  | `valueInMax` | `uint256`   | maximum amount token to buy                               |
  | `deadline`   | `uint256`   | Deadlint to buy, should be greater than `block.timestamp` |
  
  `returns`
  
  | Name    | Type      | Description                                    |
  | ------- | --------- | ---------------------------------------------- |
  | `value` | `uint256` | amount token used to buy `amountOut` resource. |
  
  ----
  
  ```
  function buyTokenValuatedResourceByExactETH(
          IResource resource,
          address[] memory prePath,
          uint256 amountOutMin,
          uint256 deadline
  ) external payable returns (uint256 amount)
  ```
  
  `params`
  
  | Name           | Type        | Description                                               |
  | -------------- | ----------- | --------------------------------------------------------- |
  | `resource`     | `IResource` | resource contract address                                 |
  | `prePath`      | `address[]` | pre path to resource `valuationToken`                     |
  | `amountOutMin` | `uint256`   | minimum amount resource to buy                            |
  | `deadline`     | `uint256`   | Deadlint to buy, should be greater than `block.timestamp` |
  
  `retrurns`
  
  | Name     | Type      | Description         |
  | -------- | --------- | ------------------- |
  | `amount` | `uint256` | amount resource got |
  
  -----
  
  ```
  function buyExactTokenValuatedResourceByETH(
          IResource resource,
          address[] memory prePath,
          uint256 amountOut,
          uint256 deadline
  ) external payable returns (uint256 value)
  ```
  
  `params`
  
  | Name        | Type        | Description                                               |
  | ----------- | ----------- | --------------------------------------------------------- |
  | `resource`  | `IResource` | resource contract address                                 |
  | `prePath`   | `address[]` | pre path to resource `valuationToken`                     |
  | `amountOut` | `uint256`   | amount resource to buy                                    |
  | `deadline`  | `uint256`   | Deadlint to buy, should be greater than `block.timestamp` |
  
  `returns`
  
  | Name    | Type      | Description                                  |
  | ------- | --------- | -------------------------------------------- |
  | `value` | `uint256` | amount ETH used to buy `amountOut` resource. |
  
  ----
  
  ```
  function buyETHValuatedResourceByExactToken(
          IResource resource,
          address[] memory prePath,
          uint256 valueIn,
          uint256 amountOutMin,
          uint256 deadline
  ) external returns (uint256 amount)
  ```
  
  `params`
  
  | Name           | Type        | Description                                               |
  | -------------- | ----------- | --------------------------------------------------------- |
  | `resource`     | `IResource` | resource contract address                                 |
  | `prePath`      | `address[]` | pre path to resource `valuationToken`                     |
  | `valueIn`      | `uint256`   | amount token to buy                                       |
  | `amountOutMin` | `uint256`   | minimum amount resource to buy                            |
  | `deadline`     | `uint256`   | Deadlint to buy, should be greater than `block.timestamp` |
  
  `returns`
  
  | Name     | Type      | Description         |
  | -------- | --------- | ------------------- |
  | `amount` | `uint256` | amount resource got |
  
  ----
  
  ```
  function buyExactETHValuatedResourceByToken(
          IResource resource,
          address[] memory prePath,
          uint256 amountOut,
          uint256 valueInMax,
          uint256 deadline
  ) external returns (uint256 value)
  ```
  
  `params`
  
  | Name         | Type        | Description                                               |
  | ------------ | ----------- | --------------------------------------------------------- |
  | `resource`   | `IResource` | resource contract address                                 |
  | `prePath`    | `address[]` | pre path to resource `valuationToken`                     |
  | `amountOut`  | `uint256`   | amount resource to buy                                    |
  | `valueInMax` | `uint256`   | maximum amount token to buy                               |
  | `deadline`   | `uint256`   | Deadlint to buy, should be greater than `block.timestamp` |
  
  `returns`
  
  | Name    | Type      | Description                                    |
  | ------- | --------- | ---------------------------------------------- |
  | `value` | `uint256` | amount token used to buy `amountOut` resource. |
  
  ----
  
  ```
  function getAmountOut(
          IResource resource,
          address[] memory prePath,
          uint256 valueIn
  ) external view returns (uint256 amountOut)
  ```
  
  `params`
  
  | Name       | Type        | Description                           |
  | ---------- | ----------- | ------------------------------------- |
  | `resource` | `IResource` | resource contract address             |
  | `prePath`  | `address[]` | pre path to resource `valuationToken` |
  | `valueIn`  | `uint256`   | amount token or ETH to use            |
  
  `returns`
  
  | Name        | Type      | Description            |
  | ----------- | --------- | ---------------------- |
  | `amountOut` | `uint256` | amount resource to get |
  
  ----
  
  ```
  function getValuesIn(
          IResource resource,
          address[] memory prePath,
          uint256 amountOut
  ) external view returns (uint256[] memory valuesIn)
  ```
  
  `params`
  
  | Name        | Type        | Description                           |
  | ----------- | ----------- | ------------------------------------- |
  | `resource`  | `IResource` | resource contract address             |
  | `prePath`   | `address[]` | pre path to resource `valuationToken` |
  | `amountOut` | `uint256`   | amount resource to get                |
  
  `returns`
  
  | Name       | Type        | Description                                              |
  | ---------- | ----------- | -------------------------------------------------------- |
  | `valuesIn` | `uint256[]` | amount token or ETH will be used in each path component. |
  
  ----
  
  ```
  function path(IResource resource, address[] memory prePath) external view returns (address[] memory fullPath)
  ```
  
  `params`
  
  | Name       | Type        | Description                           |
  | ---------- | ----------- | ------------------------------------- |
  | `resource` | `IResource` | resource contract address             |
  | `prePath`  | `address[]` | pre path to resource `valuationToken` |
  
  `returns`
  
  | Name       | Type        | Description                             |
  | ---------- | ----------- | --------------------------------------- |
  | `fullPath` | `address[]` | full path to  resource `valuationToken` |
  
  
