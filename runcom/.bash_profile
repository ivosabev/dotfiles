# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

READLINK=$(which greadlink 2>/dev/null || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,path,env,alias,grep,prompt,nvm,completion,custom}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Set LSCOLORS

eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# Hook for extra/custom stuff

DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
  for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/runcom/*.sh; do
    [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
  done
fi

# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# CUSTOM
unset JAVA_HOME
export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0_282`
export PATH=$PATH:$JAVA_HOME/bin

export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=~/Library/Android/sdk
export ANDROID_NDK_HOME=/usr/local/share/android-ndk

export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export NODE_ENV="development"
export GITHUB_AUTH=""

# Export

export DOTFILES_DIR DOTFILES_EXTRA_DIR

# PHP

# export PATH="/usr/local/opt/php@7.1/bin:$PATH"
# export PATH="/usr/local/opt/php@7.1/sbin:$PATH"

export PATH="/usr/local/opt/php@5.6/bin:$PATH"
export PATH="/usr/local/opt/php@5.6/sbin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
