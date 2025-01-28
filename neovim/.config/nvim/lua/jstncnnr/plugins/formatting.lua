return {
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disabled_types = {
					c = true,
					cpp = true,
				}
				return {
					timeout_ms = 1000,
					lsp_fallback = not disabled_types[vim.bo[bufnr].filetype],
				}
			end,
			ft_parsers = {
				javascript = "babel",
				javascriptreact = "babel",
				typescript = "typescript",
				typescriptreact = "typescript",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				php = { "pint" },
			},
		},
	},
}
