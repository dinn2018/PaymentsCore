import { BigNumber } from 'ethers'

export const oneToken = BigNumber.from('1000000000000000000')

export const toToken = (value: string) => {
	if(parseFloat(value) < 1) {
		return BigNumber.from((parseFloat(value) * 1e18).toString())
	}
	return BigNumber.from(value).mul(oneToken)
}

export const formatToken = (value: BigNumber) => {
	if (value < oneToken) {
		return (value.toNumber()/1e18).toFixed(18)
	}
	return value.div(oneToken).toString()
}

export const defaultDeadline =  ()=> {
	return BigNumber.from(Math.floor(Date.now()/1000+100000))
}