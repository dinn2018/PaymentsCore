import '@nomiclabs/hardhat-ethers'
import 'hardhat-deploy'

import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { Payment__factory } from '../types/factories/Payment__factory'
import { RootChannel__factory } from '../types/factories/RootChannel__factory'
import { SimpleResourceERC20__factory } from '../types/factories/SimpleResourceERC20__factory'
import { SimpleResourceETH__factory } from '../types/factories/SimpleResourceETH__factory'
import { StorageWithDeadline__factory } from '../types/factories/StorageWithDeadline__factory'

export const SimpleResourceERC20 = async (env: HardhatRuntimeEnvironment) => {
	const deployment = await env.deployments.get(SimpleResourceERC20.name)
	const signers = await env.ethers.getSigners()
	return SimpleResourceERC20__factory.connect(deployment.address, signers[0])
}

export const SimpleResourceETH = async (env: HardhatRuntimeEnvironment) => {
	const deployment = await env.deployments.get(SimpleResourceETH.name)
	const signers = await env.ethers.getSigners()
	return SimpleResourceETH__factory.connect(deployment.address, signers[0])
}

export const StorageWithDeadline = async (env: HardhatRuntimeEnvironment) => {
	const deployment = await env.deployments.get(StorageWithDeadline.name)
	const signers = await env.ethers.getSigners()
	return StorageWithDeadline__factory.connect(deployment.address, signers[0])
}

export const Payment = async (env: HardhatRuntimeEnvironment) => {
	const deployment = await env.deployments.get(Payment.name)
	const signers = await env.ethers.getSigners()
	return Payment__factory.connect(deployment.address, signers[0])
}

export const RootChannel = async (env: HardhatRuntimeEnvironment)=>{
	const deployment = await env.deployments.get(RootChannel.name)
	const signers = await env.ethers.getSigners()
	return RootChannel__factory.connect(deployment.address, signers[0])
}

