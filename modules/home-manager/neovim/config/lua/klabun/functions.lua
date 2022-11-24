local M = {}

M.open_project_file = function()
	require("telescope.builtin").find_files({})
end

M.recent_project_files = function()
	require("telescope.builtin").oldfiles({
		cwd_only = true,
	})
end

M.recent_projects = function()
	require("telescope").extensions.projects.projects({})
end

M.grep_in_project = function()
	require("telescope.builtin").live_grep({})
end

M.symbol_in_project = function()
	require("telescope.builtin").lsp_workspace_symbols({})
end

return M
