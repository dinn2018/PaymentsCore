import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { DeployFunction, DeploymentsExtension } from 'hardhat-deploy/types'

import SimpleResourceERC20 from '../artifacts/contracts/resources/SimpleResourceERC20.sol/SimpleResourceERC20.json'
import SimpleResourceETH from '../artifacts/contracts/resources/SimpleResourceETH.sol/SimpleResourceETH.json'
import InternalSwapResourceERC20 from '../artifacts/contracts/resources/InternalSwapResourceERC20.sol/InternalSwapResourceERC20.json'
import RootChannel from '../artifacts/contracts/channels/RootChannel.sol/RootChannel.json'
import Payment from '../artifacts/contracts/Payment.sol/Payment.json'
import { BigNumber } from 'ethers'

let from = ''
let dep: DeploymentsExtension

const router = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D'
const usdt = '0xE437E9a5fd870aF20a779A5fBA83bc53cC7C837A'
const ever = '0xc0D05413823E6ebeA748285d468295eB384057A9'
const receiver = '0x1d1B1b329bA09f0124F9B26edAA29c80F0275263'
const oneToken = BigNumber.from(1e18.toString())

const deployFuc: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {

	const { deployments, getNamedAccounts, ethers, network } = hre
	const { deployer } = await getNamedAccounts()
	from = deployer
	dep = deployments

	const isMainNet = network.config.chainId == 1
	const payment = await deploy(Payment, 
		[
			router,
			isMainNet?
				'0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2':
				'0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6'
		]
	)
	// goerli
	// _checkpointManager 0x2890bA17EfE978480615e330ecB65333b880928e
	// _root 0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA
	// mainnet
	// _checkpointManager 0x86e4dc95c7fbdbf52e33d563bbdb00823894c287
	// _root 0xfe5e5D361b2ad62c541bAb87C45a0B9B018389a2
	const rootChannle = await deploy(RootChannel, [
		isMainNet?
			'0x86e4dc95c7fbdbf52e33d563bbdb00823894c287':
			'0x2890bA17EfE978480615e330ecB65333b880928e', 
		isMainNet?
			'0xfe5e5D361b2ad62c541bAb87C45a0B9B018389a2':
			'0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA'
	])

	const simpleResourceERC20 = await deploy(SimpleResourceERC20, [
		rootChannle,
		usdt,
		oneToken,
		receiver
	])
	const simpleResourceERC20Factory = await ethers.getContractFactory(SimpleResourceERC20.contractName)
	const simpleResourceERC20Functions = simpleResourceERC20Factory.attach(simpleResourceERC20).functions
	let tx = await simpleResourceERC20Functions.permit(payment, true)
	let receipt = await tx.wait()
	console.log('simpleResourceERC20Functions.permit', receipt)

	const simpleResourceETH = await deploy(SimpleResourceETH, [
		rootChannle,
		isMainNet?
			'0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2':
			'0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6',
		1,
		receiver
	])
	const simpleResourceETHFactory = await ethers.getContractFactory(SimpleResourceETH.contractName)
	const simpleResourceETHFunctions = simpleResourceETHFactory.attach(simpleResourceETH).functions
	tx = await simpleResourceETHFunctions.permit(payment, true)
	receipt = await tx.wait()
	console.log('simpleResourceETHFunctions.permit', receipt)

	const internalSwapResourceERC20 = await deploy(InternalSwapResourceERC20, [
		rootChannle,
		usdt,
		ever,
		receiver,
		router,
		oneToken
	])
	const internalSwapResourceERC20Factory = await ethers.getContractFactory(InternalSwapResourceERC20.contractName)
	const internalSwapResourceERC20Functions = internalSwapResourceERC20Factory.attach(internalSwapResourceERC20).functions
	tx = await internalSwapResourceERC20Functions.permit(payment, true)
	receipt = await tx.wait()
	console.log('internalSwapResourceERC20Functions.permit', receipt)

	const channelFactory = await ethers.getContractFactory(RootChannel.contractName)
	const channelFunctions = channelFactory.attach(rootChannle).functions
	tx = await channelFunctions.permit(simpleResourceERC20, true)
	receipt = await tx.wait()
	console.log('channelFunctions.permit.simpleResourceERC20', receipt)
	tx = await channelFunctions.permit(simpleResourceETH, true)
	receipt = await tx.wait()
	console.log('channelFunctions.permit.simpleResourceETH', receipt)
	tx = await channelFunctions.permit(internalSwapResourceERC20, true)
	receipt = await tx.wait()
	console.log('channelFunctions.permit.internalSwapResourceERC20', receipt)

}

async function deploy(contract: any, args: any[] = []): Promise<string> {
	await dep.deploy(contract.contractName, {
		from,
		contract,
		args,
		log: true
	})
	const deployResult = await dep.get(contract.contractName)
	const addr = deployResult.address
	console.log(`${contract.contractName} deployed: `, addr)
	return addr
}

deployFuc.tags = [
	SimpleResourceERC20.contractName,
	SimpleResourceETH.contractName,
	InternalSwapResourceERC20.contractName,
	Payment.contractName,
	RootChannel.contractName,
]

export default deployFuc
