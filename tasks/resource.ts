import '@nomiclabs/hardhat-ethers'
import 'hardhat-deploy'

import { task } from 'hardhat/config'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { SimpleResourceERC20, SimpleResourceETH, InternalSwapResourceERC20 } from './contracts'

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

task('InternalSwapResourceERC20:balances')
	.addOptionalParam('to', 'address')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const internalSwapResourceERC20 = await InternalSwapResourceERC20(env)
		const balances = await internalSwapResourceERC20.balances(args.to)
		console.log('balances', balances)
	})

module.exports = {}