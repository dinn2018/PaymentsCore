module.exports = {
	singleQuote: true,
	bracketSpacing: true,
	overrides: [
		{
			files: '*.sol',
			options: {
				printWidth: 80,
				useTabs: true,
				singleQuote: false,
				bracketSpacing: false,
				explicitTypes: 'always'
			}
		}
	]
}
