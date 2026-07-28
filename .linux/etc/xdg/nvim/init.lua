-- 1. 禁用鼠标
vim.opt.mouse = ""

-- 2. 记住上次打开位置
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lnum = mark[1]
        local col = mark[2]
        if lnum > 1 and lnum <= vim.fn.line("$") then
            vim.api.nvim_win_set_cursor(0, { lnum, col })
        end
    end,
})

-- 可选：显示行号
-- vim.opt.number = true

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })

-- 可选：启用相对行号
-- vim.opt.relativenumber = true

