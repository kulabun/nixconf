require 'klabun.options'
require 'klabun.core'
require 'klabun.plugins'
require 'klabun.mappings'
require 'klabun.autocmds'

function P(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
