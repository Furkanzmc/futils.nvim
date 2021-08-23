local vim = vim
local M = {}

-- table {{{

function table.index_of(tab, val)
    for index, value in ipairs(tab) do if value == val then return index end end

    return -1
end

function table.extend(source, target)
    for _, v in ipairs(target) do table.insert(source, v) end

    return source
end

function table.filter(t, pred)
    local out = {}

    for k, v in pairs(t) do if pred(v, k, t) then table.insert(out, v) end end

    return out
end

function table.map(t, pred)
    local out = {}

    for k, v in pairs(t) do table.insert(out, pred(v, k, t)) end

    return out
end

function table.for_each(t, func)
    local out = {}

    for k, v in pairs(t) do func(v, k) end

    return out
end

function table.uniq(t)
    local new_table = {}
    local hash = {}
    for _, v in pairs(t) do
        if not hash[v] then
            table.insert(new_table, v)
            hash[v] = true
        end
    end

    return new_table
end

-- }}}

-- string {{{

function string.join(str, ch)
    local joined = ""
    for _, word in ipairs(str) do joined = joined .. ch .. word end

    return joined
end

function string.split(str, sep)
    local ret = {}
    local n = 1
    for w in str:gmatch("([^" .. sep .. "]*)") do
        ret[n] = ret[n] or w -- only set once (so the blank after a string is ignored)
        if w == "" then n = n + 1 end -- step forwards on a blank but not a string
    end

    if type(ret) ~= "table" then ret = {ret} end

    return ret
end

function string.starts_with(str, start)
    return string.sub(str, 1, str.len(start)) == start
end

-- }}}

function M.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    if opts.buffer ~= nil then
        assert(type(opts.buffer) == "number")

        local bufnr = opts.buffer
        options.buffer = nil
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end
end

return M
