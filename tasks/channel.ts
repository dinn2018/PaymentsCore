import '@nomiclabs/hardhat-ethers'
import 'hardhat-deploy'

import { task } from 'hardhat/config'
import { HardhatRuntimeEnvironment } from 'hardhat/types'
import { RootChannel } from './contracts'

task('channel', 'params')
	.addOptionalParam('child','child channel address')
	.addOptionalParam('msg', 'receive message from child')
	.setAction(async (args:any, env: HardhatRuntimeEnvironment)=>{
		const channel = await RootChannel(env)
		if (args.child) {
			const tx = await channel.setChildChannel(args.child)
			console.log('setChildChannel', tx)
			const receipt = await tx.wait()
			console.log('receipt', receipt)
		}
		if (args.msg) {
			const tx = await channel.receiveMessage(args.msg)
			console.log('receiveMessage', tx)
			const receipt = await tx.wait()
			console.log('receipt', receipt)
		}
	})

module.exports = {}