# 02-path.zsh — PATH exports

export PATH="$HOME/.local/bin:$HOME/.symfony5/bin:$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# rg config path
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"

# dotnet tools
export PATH="$PATH:/home/yushi61/.dotnet/tools"

# Default editor
export EDITOR="nvim"

# Android SDK 
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
