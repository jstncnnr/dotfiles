return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		main = 'nvim-treesitter.configs',
		opts = {
			ensure_installed = { 'diff', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
			auto_install = true,
			highlight = {
				enable = true;
			},
			indent = {
				enable = true;
			},
		},
	},
}
