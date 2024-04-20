return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-go",
	},
	config = function()
		-- get neotest namespace (api call creates or returns namespace)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		local neotest = require("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message =
						diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		vim.keymap.set('n', '<leader>tt', function() neotest.run.run() end,
			{ desc = 'Test single function on hover' })
		vim.keymap.set('n', '<leader>tf', function() neotest.run.run(vim.fn.expand('%')) end,
			{ desc = 'Test entire file' })
		vim.keymap.set('n', '<leader>to', function() neotest.output.open() end,
			{ desc = 'Show test output' })
		vim.keymap.set('n', '<leader>top', function() neotest.output_panel.toggle() end,
			{ desc = 'Show test output panel' })
		vim.keymap.set('n', '<leader>ts', function() neotest.summary.toggle() end,
			{ desc = 'Show test output panel' })

		neotest.setup({
			-- your neotest config here
			adapters = {
				require("neotest-go")({
					experimental = {
						test_table = true,
					},
					args = { "-count=1", "-timeout=60s" }
				}),
			},
		})
	end,
}
