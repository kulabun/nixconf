require 'klabun.options'
require 'klabun.core'
require 'klabun.mappings'
require 'klabun.plugins'

function P(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end
