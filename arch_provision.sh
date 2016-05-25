# enable pacman colors
sudo sed -i 's/#Color/Color/' /etc/pacman.conf

yes | sudo pacman -Syu --needed git hub neovim zsh tmux stow

#clone dotfiles
if [[ ! -d ~/.dotfiles ]]; then
  git clone git://github.com/ZhengzhongZhang/dotfiles ~/.dotfiles
  (cd ~/.dotfiles && for D in */; do stow $D; done)
fi

#install vim-plug
if [[ ! -d ~/.config/nvim/autoload/plug.vim/ ]]; then
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

#install prezto
if [[ ! -d ~/.zprezto ]]; then
  git clone --recursive git://github.com/ZhengzhongZhang/prezto.git "$HOME/.zprezto"

  zsh -c '
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done'

  sudo chsh -s /bin/zsh $USER
fi
