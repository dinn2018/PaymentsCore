import '@nomiclabs/hardhat-ethers'
import 'hardhat-deploy'

import { task } from 'hardhat/config'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { Payment } from './contracts'
import { toToken, defaultDeadline } from './utils'

task('payment:getValuesIn', 'getValuesIn')
	.addParam('resource', 'resource')
	.addOptionalParam('prepath','prePath to resource')
	.addOptionalParam('ao', 'amount out')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const getValuesIn = await payment.getValuesIn(
			args.resource,
			tokens,
			args.ao
		)
		console.log('getValuesIn', getValuesIn)
	})

task('payment:getAmountOut', 'getValuesIn')
	.addParam('resource', 'resource')
	.addOptionalParam('prepath','prePath to resource')
	.addOptionalParam('vi', 'value in')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const getAmountOut = await payment.getAmountOut(
			args.resource,
			tokens,
			toToken(args.vi)
		)
		console.log('getAmountOut', getAmountOut)
	})

task('payment:buyExactTokenValuatedResourceByOtherToken', 'buyExactTokenValuatedResourceByOtherToken')
	.addParam('resource', 'resource')
	.addParam('prepath','prePath to resource')
	.addOptionalParam('ao', 'amount out')
	.addOptionalParam('vimax', 'valueInMax')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const tx = await payment.buyExactTokenValuatedResourceByOtherToken(
			args.resource,
			tokens,
			args.ao,
			toToken(args.vimax),
			args.deadline || defaultDeadline()
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyTokenValuatedResourceByOtherExactToken', 'buyTokenValuatedResourceByOtherExactToken')
	.addParam('resource', 'resource')
	.addParam('prepath','prePath to resource')
	.addOptionalParam('vi', 'valueIn')
	.addOptionalParam('aomin', 'amount out min')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const tx = await payment.buyTokenValuatedResourceByOtherExactToken(
			args.resource,
			tokens,
			toToken(args.vi),
			args.aomin,
			args.deadline || defaultDeadline()
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyTokenValuatedResourceByExactETH', 'buyTokenValuatedResourceByExactETH')
	.addParam('resource', 'resource')
	.addParam('prepath','prePath to resource')
	.addOptionalParam('value', 'ETH value')
	.addOptionalParam('aomin', 'amount out min')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const tx = await payment.buyTokenValuatedResourceByExactETH(
			args.resource,
			tokens,
			args.aomin,
			args.deadline || defaultDeadline(),
			{
				value: toToken(args.value),
			}
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyExactTokenValuatedResourceByETH', 'buyExactTokenValuatedResourceByETH')
	.addParam('resource', 'resource')
	.addParam('prepath','prePath to resource')
	.addOptionalParam('value', 'ETH value')
	.addOptionalParam('ao', 'amount out')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const tx = await payment.buyTokenValuatedResourceByExactETH(
			args.resource,
			tokens,
			args.ao,
			args.deadline || defaultDeadline(),
			{
				value: toToken(args.value),
			}
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyETHValuatedResourceByExactToken', 'buyETHValuatedResourceByExactToken')
	.addParam('resource', 'resource')
	.addParam('prepath','prePath to resource')
	.addOptionalParam('vi', 'value token')
	.addOptionalParam('aomin', 'amount out')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const tx = await payment.buyETHValuatedResourceByExactToken(
			args.resource,
			tokens,
			toToken(args.vi),
			args.aomin,
			args.deadline || defaultDeadline(),
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyExactETHValuatedResourceByToken', 'buyExactETHValuatedResourceByToken')
	.addParam('resource', 'resource')
	.addParam('prepath','prePath to resource')
	.addOptionalParam('ao', 'amount out')
	.addOptionalParam('vimax', 'value token')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tokens = String(args.prepath).split(',')
		const tx = await payment.buyExactETHValuatedResourceByToken(
			args.resource,
			tokens,
			args.ao,
			toToken(args.vimax),
			args.deadline || defaultDeadline(),
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyTokenValuatedResourceByExactToken', 'buyTokenValuatedResourceByExactToken')
	.addParam('resource', 'resource')
	.addParam('vi', 'value token')
	.addOptionalParam('aomin', 'amount out min', '0')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tx = await payment.buyTokenValuatedResourceByExactToken(
			args.resource,
			toToken(args.vi),
			args.aomin,
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})


task('payment:buyExactTokenValuatedResourceByToken', 'buyExactTokenValuatedResourceByToken')
	.addParam('resource', 'resource')
	.addParam('ao', 'amount out')
	.addParam('vimax', 'value token')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tx = await payment.buyExactTokenValuatedResourceByToken(
			args.resource,
			args.ao,
			toToken(args.vimax),
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyETHValuatedResourceByExactETH', 'buyETHValuatedResourceByExactETH')
	.addParam('resource', 'resource')
	.addParam('aom', 'amount out min')
	.addParam('value', 'ETH value')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tx = await payment.buyETHValuatedResourceByExactETH(
			args.resource,
			args.aom,
			{
				value: toToken(args.value)
			}
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('payment:buyExactETHValuatedResourceByETH', 'buyExactETHValuatedResourceByETH')
	.addParam('resource', 'resource')
	.addParam('ao', 'amount out')
	.addParam('value', 'ETH value max')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args: any, env: HardhatRuntimeEnvironment) => {
		const payment = await Payment(env)
		const tx = await payment.buyExactETHValuatedResourceByETH(
			args.resource,
			args.ao,
			{
				value: toToken(args.value)
			}
		)
		console.log('tx', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

module.exports = {}