Download
========

```
cd ~
git clone https://github.com/darkSasori/bashfiles.git .bash
```

Install Bash
============

```
echo "source ~/.bash/bashrc" >> ~/.bashrc
echo ". ~/.bashrc" >> ~/.bash_profile
```

Install tmux
============

```
touch ~/.tmux-local.conf
ln -sv ~/.bash/tmux.conf ~/.tmux.conf
```

Install Yaourt
=============

```
ln -sv ~/.bash/yaourtrc ~/.yaourtrc
```
