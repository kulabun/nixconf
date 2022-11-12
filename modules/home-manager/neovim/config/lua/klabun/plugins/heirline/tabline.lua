M = {}

M.buffer_line = function()
  local utils = require("heirline.utils")

  function separator(icon)
    local Separator = {
      provider = icon,
      hl = function(self)
        return {
          fg = utils.get_highlight("TabLineSel").bg,
          bg = utils.get_highlight("TabLineFill").bg,
        }
      end,
    }
    return Separator
  end

  function tab_file_block()
    local TabFileBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        return self.is_active and "TabLineSel" or "TabLine"
      end,
      separator(""),
      {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
            filename,
            extension,
            { default = true }
          )
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      },
      {
        provider = function(self)
          local filename = vim.api.nvim_buf_get_name(self.bufnr)
          if filename == "" then
            return "[No Name]"
          else
            return vim.fn.fnamemodify(filename, ":t")
          end
        end,
        hl = function(self)
          return {
            bold = self.is_active or self.is_visible,
            italic = true,
          }
        end,
      },
      {
        {
          condition = function(self)
            return vim.api.nvim_buf_get_option(self.bufnr, "modified")
          end,
          provider = "[+]",
          hl = { fg = "green" },
        },
        {
          condition = function(self)
            return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
                or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
          end,
          provider = function(self)
            if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
              return "  "
            else
              return ""
            end
          end,
          hl = { fg = "orange" },
        },
      },
      {
        condition = function(self)
          return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
        end,
        { provider = " " },
        {
          provider = "",
          hl = { fg = "gray" },
          on_click = {
            callback = function(_, minwid)
              vim.api.nvim_buf_delete(minwid, { force = false })
            end,
            minwid = function(self)
              return self.bufnr
            end,
            name = "heirline_tabline_close_buffer_callback",
          },
        },
      },
      separator(""),
    }
    return TabFileBlock
  end

  local BufferLine = utils.make_buflist(
    tab_file_block(),
    { provider = "", hl = { fg = "gray" } },
    { provider = "", hl = { fg = "gray" } }
  )

  return BufferLine
end

return M
