function fish_user_key_bindings
  # fzf
  bind \cf fzf_change_directory

  # vim-like
  bind \cl forward-char

end

# fzf plugin
fzf_configure_bindings --directory=\co
