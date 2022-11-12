local M = {}

local utils = require("heirline.utils")
local conditions = require("heirline.conditions")

local Align = { provider = "%=" }
local Space = { provider = " " }
local Split = { provider = " | ", hl = { fg = "gray_dark", bg = "bg_dark" } }
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
      ["r"] = { "PROMPT", "command" },
      ["rm"] = { "MORE", "command" },
      ["r?"] = { "CONFIRM", "command" },

      ["!"] = { "SHELL", "command" },

      ["t"] = { "TERM", "insert" },
      ["nt"] = { "TERM", "normal" },

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
  {
    provider = function(self)
      return " %2(" .. self.modes[self.mode][1] .. "%) "
      -- return " "
    end,
    hl = function(self)
      local mode = self.modes[self.mode][2]
      return { bg = self.mode_colors[mode], fg = "bg_dark", bold = true }
    end,
    update = { "ModeChanged", "CmdlineLeave", "CmdwinLeave" },
  },
  Space,
}
local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.added = self.status_dict.added or 0
    self.removed = self.status_dict.removed or 0
    self.changed = self.status_dict.changed or 0
    self.has_changes = self.added > 0 or self.removed > 0 or self.changed > 0
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
    condition = function(self)
      return self.added > 0
    end,
    provider = function(self)
      return self.added > 0 and ("+" .. self.added)
    end,
    hl = { fg = "green" },
  },
  {
    condition = function(self)
      return self.removed > 0
    end,
    provider = function(self)
      return self.removed > 0 and ("-" .. self.removed)
    end,
    hl = { fg = "red" },
  },
  {
    condition = function(self)
      return self.changed > 0
    end,
    provider = function(self)
      return self.changed > 0 and ("~" .. self.changed)
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
local Diagnostics = {
  condition = conditions.has_diagnostics,
  update = { "DiagnosticChanged", "BufEnter" },
  hl = { bg = "bg_dark" },

  Split,
  {
    provider = function()
      local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      local icon = " "
      return errors > 0 and (icon .. errors .. " ")
    end,
    hl = { fg = "red" },
  },
  {
    provider = function(self)
      local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      local icon = " "
      return warnings > 0 and (icon .. warnings .. " ")
    end,
    hl = { fg = "orange" },
  },
  {
    provider = function(self)
      local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      local icon = " "
      return info > 0 and (icon .. info .. " ")
    end,
    hl = { fg = "cyan" },
  },
  {
    provider = function(self)
      local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      local icon = " "
      return hints > 0 and (icon .. hints)
    end,
    hl = { fg = "yellow" },
  },
}
local FileEncoding = {
  Split,
  {
    provider = function()
      return vim.bo.fenc:upper()
    end,
  },
}
local FileSystem = {
  Split,
  {
    provider = function()
      local fmt = vim.bo.fileformat:lower()
      if fmt == "unix" then
        return "LF"
      elseif fmt == "mac" then
        return "CR"
      elseif fmt == "dos" then
        return "CRLF"
      else
        return ""
      end
    end,
  },
}
local Location = {
  Split,
  {
    provider = "L:%l C:%c",
  },
}
local Ruler = {
  Split,
  -- Split,
  -- {
  --   provider = "%10(L:%l C:%c%)",
  -- },
  {
    provider = " %P ",
    hl = { bg = "bg_dark", fg = "white", bold = true },
  },
}
local LanguageServer = {
  condition = conditions.lsp_attached,
  init = function(self)
    local servers = vim.lsp.get_active_clients()
    for _, server in ipairs(servers) do
      if server.name == "null-ls" then
        self.null_ls = server
      elseif server.name == "copilot" then
        self.copilot = server
      else
        self.server = server
      end
    end
    if not self.server and self.null_ls then
      self.server = self.null_ls
    end
  end,
  Split,
  {
    provider = function()
      -- return " "
      -- return " [LSP] "
      return "LSP: "
    end,
    hl = function(self)
      return { fg = "yellow", bg = "bg_dark", bold = true }
    end,
  },
  {
    provider = function(self)
      return self.server and self.server.name or "--"
    end,
    hl = { fg = "white", bg = "bg_dark" },
  },
}
local Treesitter = {
  Split,
  {
    condition = function()
      local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
      return ts_avail and ts.has_parser()
    end,
    provider = function()
      return " "
    end,
    hl = function()
      local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
      return {
        fg = (ts_avail and ts.has_parser()) and "yellow" or "gray_dark",
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
local Copilot = {
  Split,
  {
    provider = function()
      -- local status = vim.fn["copilot#Enabled"]() == 1
      -- return status and "" or ""
      return " "
    end,
    hl = function()
      local status = vim.fn["copilot#Enabled"]() == 1
      return { fg = status and "yellow" or "gray_dark", bg = "bg_dark", bold = true }
    end,
  },
}

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
      condition = function(self)
        return self.has_engine
      end,
      Split,
      {
        {
          provider = function(self)
            return icon
          end,
          hl = function(self)
            return { fg = "yellow", bg = "bg_dark", bold = true }
          end,
        },
        {
          provider = function(self)
            return self.has_engine and self.engine.name or "--"
          end,
          hl = { fg = "white", bg = "bg_dark" },
        },
      },
    },
  }
  return Engine
end

M.formatter = function()
  local method = require("null-ls").methods.FORMATTING
  return null_ls(method, "FMT: ")
end

M.linter = function()
  local method = require("null-ls").methods.DIAGNOSTICS
  return null_ls(method, "LINT: ")
end

M.statusline = function()
  local statusline = {
    ViMode,
    {
      condition = function()
        local mode = vim.fn.mode(1) -- :h mode()
        return mode ~= "t" and mode ~= "nt"
      end,
      Git,
      Diagnostics,
      Location,

      Align,

      LanguageServer,
      M.linter(),
      M.formatter(),
      Treesitter,
      Copilot,
      FileEncoding,
      FileSystem,
      Ruler,
      Space,
      Space,
    },
  }
  return statusline
end

return M.statusline()
