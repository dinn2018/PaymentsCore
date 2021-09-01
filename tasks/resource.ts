import '@nomiclabs/hardhat-ethers'
import 'hardhat-deploy'

import { task } from 'hardhat/config'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { SimpleResourceERC20, SimpleResourceETH, InternalSwapResourceERC20, BuyBackResource} from './contracts'
import { toToken,defaultDeadline } from './utils'

task('SimpleResourceETH:permit')
	.addOptionalParam('to','address')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const resource = await SimpleResourceETH(env)
		const tx = await resource.permit(args.to, true)
		console.log('permit', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('SimpleResourceERC20:permit')
	.addOptionalParam('to','address')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const resource = await SimpleResourceERC20(env)
		const tx = await resource.permit(args.to, true)
		console.log('permit', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('InternalSwapResourceERC20:permit')
	.addOptionalParam('to','address')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const internalSwapResourceERC20 = await InternalSwapResourceERC20(env)
		const tx = await internalSwapResourceERC20.permit(args.to, true)
		console.log('permit', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('InternalSwapResourceERC20:setPrice')
	.addOptionalParam('price', 'price')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const internalSwapResourceERC20 = await InternalSwapResourceERC20(env)
		const tx = await internalSwapResourceERC20.setPrice(args.price)
		console.log('setPrice', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

task('SimpleResourceERC20:balances')
	.addOptionalParam('to', 'address')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const simpleResourceERC20 = await SimpleResourceERC20(env)
		const balances = await simpleResourceERC20.balances(args.to)
		console.log('balances', balances)
	})

task('InternalSwapResourceERC20:balances')
	.addOptionalParam('to', 'address')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const internalSwapResourceERC20 = await InternalSwapResourceERC20(env)
		const balances = await internalSwapResourceERC20.balances(args.to)
		console.log('balances', balances)
	})

task('BuyBackResource:buyBack')
	.addParam('path', 'path')
	.addParam('value', 'valueIn')
	.addOptionalParam('aom','amountOutMin', '0')
	.addOptionalParam('deadline', 'deadline')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const tokens = String(args.path).split(',')
		const buyBackResource = await BuyBackResource(env)
		const tx = await buyBackResource.buyBack(
			tokens, 
			toToken(args.value), 
			toToken(args.aom),
			args.deadline || defaultDeadline(),
		)
		console.log('buyBack', tx)
		const receipt = await tx.wait()
		console.log('receipt', receipt)
	})

module.exports = {}