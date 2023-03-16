require("bufferline").setup{
  options = {
    numbers = "none",
    right_mouse_command = "Bdelete! %d",
    left_mouse_command = "buffer %d",
    diagnostics = "nvim_lsp",
    offsets = { { filestype = "NvimTree", text = "", padding = 1 } },
  }
}
