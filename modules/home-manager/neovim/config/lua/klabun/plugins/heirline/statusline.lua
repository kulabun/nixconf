local M = {}

M.vi_mode = function()
  local ViMode = {
    init = function(self)
      self.mode = vim.fn.mode(1) -- :h mode()

      if not self.once then
        vim.api.nvim_create_autocmd("ModeChanged", {
          pattern = "*:*o",
          command = "redrawstatus",
        })
        self.once = true
      end
    end,
    static = {
      modes = {
        ["n"] = { "NORMAL", "normal" },
        ["no"] = { "OP", "normal" },
        ["nov"] = { "OP", "normal" },
        ["noV"] = { "OP", "normal" },
        ["no"] = { "OP", "normal" },
        ["niI"] = { "NORMAL", "normal" },
        ["niR"] = { "NORMAL", "normal" },
        ["niV"] = { "NORMAL", "normal" },
        ["i"] = { "INSERT", "insert" },
        ["ic"] = { "INSERT", "insert" },
        ["ix"] = { "INSERT", "insert" },
        ["t"] = { "TERM", "insert" },
        ["nt"] = { "TERM", "insert" },
        ["v"] = { "VISUAL", "visual" },
        ["vs"] = { "VISUAL", "visual" },
        ["V"] = { "LINES", "visual" },
        ["Vs"] = { "LINES", "visual" },
        [""] = { "BLOCK", "visual" },
        ["s"] = { "BLOCK", "visual" },
        ["R"] = { "REPLACE", "replace" },
        ["Rc"] = { "REPLACE", "replace" },
        ["Rx"] = { "REPLACE", "replace" },
        ["Rv"] = { "V-REPLACE", "replace" },
        ["s"] = { "SELECT", "visual" },
        ["S"] = { "SELECT", "visual" },
        [""] = { "BLOCK", "visual" },
        ["c"] = { "COMMAND", "command" },
        ["cv"] = { "COMMAND", "command" },
        ["ce"] = { "COMMAND", "command" },
        ["r"] = { "PROMPT", "inactive" },
        ["rm"] = { "MORE", "inactive" },
        ["r?"] = { "CONFIRM", "inactive" },
        ["!"] = { "SHELL", "inactive" },
        ["null"] = { "null", "inactive" },
      },
      mode_colors = {
        normal = "green",
        insert = "red",
        replace = "orange",
        visual = "cyan",
        command = "yellow",
        inactive = "grey",
      },
    },
    provider = function(self)
      return "%2(" .. self.modes[self.mode][1] .. "%)"
    end,
    hl = function(self)
      local mode = self.modes[self.mode][2]
      return { fg = self.mode_colors[mode], bg = "bg_dark", bold = true }
    end,
    update = { "ModeChanged" },
  }

  return ViMode
end

M.treesitter = function()
  local Treesitter = {
    {
      provider = function()
        return " "
      end,
      hl = function()
        local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
        return {
          fg = (ts_avail and ts.has_parser()) and "green" or "gray_dark",
          bg = "bg_dark",
          bold = true,
        }
      end,
    },
    {
      provider = function()
        return vim.bo.filetype
      end,
      hl = { fg = "white", bg = "bg_dark" },
    },
  }

  return Treesitter
end

M.copilot = function()
  local Copilot = {
    provider = function()
      -- local status = vim.fn["copilot#Enabled"]() == 1
      -- return status and "" or ""
      return " "
    end,
    hl = function()
      local status = vim.fn["copilot#Enabled"]() == 1
      return { fg = status and "green" or "gray_dark", bg = "bg_dark", bold = true }
    end,
  }

  return Copilot
end

M.file_encoding = function()
  local FileEncoding = {
    provider = function()
      return vim.bo.fenc:upper()
    end,
  }
  return FileEncoding
end

M.file_system = function()
  local utils = require("heirline.utils")
  local FileSystem = {
    provider = function()
      local fmt = vim.bo.fileformat:lower()
      if fmt == "unix" then
        return " <LF>"
      elseif fmt == "mac" then
        return " <CR>"
      elseif fmt == "dos" then
        return " <CR><LF>"
      else
        return ""
      end
    end,
  }
  return FileSystem
end

M.file_size = function()
  local utils = require("heirline.utils")
  local FileSize = {
    provider = function()
      -- stackoverflow, compute human readable file size
      local suffix = { "b", "k", "M", "G", "T", "P", "E" }
      local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
      fsize = (fsize < 0 and 0) or fsize
      if fsize < 1024 then
        return fsize .. suffix[1]
      end
      local i = math.floor((math.log(fsize) / math.log(1024)))
      return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
    end,
  }
  return FileSize
end

M.ruler = function()
  local Ruler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = "%13(%l/%L:%c%) %P",
  }
  return Ruler
end

M.git = function()
  local utils = require("heirline.utils")
  local conditions = require("heirline.conditions")
  local Git = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0
          or self.status_dict.removed ~= 0
          or self.status_dict.changed ~= 0
    end,
    hl = { fg = "white", bg = "bg_dark" },

    {
      provider = function(self)
        return " " .. self.status_dict.head
      end,
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = "(",
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ("+" .. count)
      end,
      hl = { fg = "green" },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ("-" .. count)
      end,
      hl = { fg = "red" },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ("~" .. count)
      end,
      hl = { fg = "yellow" },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = ")",
    },
  }

  return Git
end

local function null_ls(method, icon)
  local nls_sources = require("null-ls.sources")

  local Engine = {
    init = function(self)
      self.filetype = vim.bo.filetype
      self.engines = nls_sources.get_available(self.filetype, method)
      self.has_engine = false
      for _, engine in ipairs(self.engines) do
        if engine.filetypes[self.filetype] then
          self.engine = engine
          self.has_engine = true
        end
      end
    end,
    {
      provider = function(self)
        return icon
      end,
      hl = function(self)
        return { fg = self.has_engine and "green" or "gray_dark", bg = "bg_dark", bold = true }
      end,
    },
    {
      provider = function(self)
        return self.has_engine and self.engine.name or "--"
      end,
      hl = { fg = "white", bg = "bg_dark" },
    },
  }
  return Engine
end

M.formatter = function()
  local method = require("null-ls").methods.FORMATTING
  return null_ls(method, " ")
end

M.linter = function()
  local method = require("null-ls").methods.DIAGNOSTICS
  return null_ls(method, "ﮒ ")
end

M.language_server = function()
  local LanguageServer = {
    init = function(self)
      local servers = vim.lsp.get_active_clients()
      for _, server in ipairs(servers) do
        if server.name ~= "null-ls" and server.name ~= "copilot" then
          self.server = server
        end
      end
    end,
    {
      provider = function()
        return " "
      end,
      hl = function(self)
        return { fg = self.server and "green" or "gray_dark", bg = "bg_dark", bold = true }
      end,
    },
    {
      provider = function(self)
        return self.server and self.server.name or "--"
      end,
      hl = { fg = "white", bg = "bg_dark" },
    },
  }
  return LanguageServer
end

M.diagnostics = function()
	local utils = require("heirline.utils")
	local conditions = require("heirline.conditions")

	local Diagnostics = {
		condition = conditions.has_diagnostics,

		static = {
			error_icon = " ",
			warn_icon = " ",
			info_icon = " ",
			hint_icon = "ﯦ ",
		},

		init = function(self)
			self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
			self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
			self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
			self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		end,

		update = { "DiagnosticChanged", "BufEnter" },
		hl = { bg = "bg_dark" },

		{
			provider = function(self)
				-- 0 is just another output, we can decide to print it or not!
				return self.errors > 0 and (self.error_icon .. self.errors .. " ")
			end,
			hl = { fg = "red" },
		},
		{
			provider = function(self)
				return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
			end,
			hl = { fg = "orange" },
		},
		{
			provider = function(self)
				return self.info > 0 and (self.info_icon .. self.info .. " ")
			end,
			hl = { fg = "cyan" },
		},
		{
			provider = function(self)
				return self.hints > 0 and (self.hint_icon .. self.hints)
			end,
			hl = { fg = "yellow" },
		},
	}

	return Diagnostics
end

return M
