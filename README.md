Download
========

```
cd ~
git clone https://github.com/darkSasori/bashfiles.git .dotfiles
```

Install Bash
============

```
echo "source ~/.dotfiles/bashrc" >> ~/.bashrc
echo ". ~/.bashrc" >> ~/.bash_profile
```

Install tmux
============

```
>> ~/.tmux-local.conf
ln -sv ~/.dotfiles/tmux.conf ~/.tmux.conf
```

Install Yaourt
=============

```
ln -sv ~/.dotfiles/yaourtrc ~/.yaourtrc
```

Install Vimrc
=============

```
ln -sv ~/.dotfiles/vimrc ~/.vimrc
```
