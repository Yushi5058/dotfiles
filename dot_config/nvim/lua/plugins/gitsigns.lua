return {
    "lewis6991/gitsigns.nvim",
    opts = {},
    lazy = true,
    config = function()
        vim.cmd("set statusline+=%{get(b:,'gitsigns_status','')}")
    end
}
