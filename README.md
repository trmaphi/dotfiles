# DOTFILES

My personal config for dotfiles, currently supported mac os with bash and zsh

## Getting Started

Clone and run the setup script `setup/.macos.setup.sh`

For spaceship-prompt 

```bash
git submodule update --init --recursive && \
ln -sf "$PWD/.spaceship-prompt/spaceship.zsh" \
"/usr/local/share/zsh/site-functions/prompt_spaceship_setup" && \
cd /Library/Fonts && \
curl -LJO https://github.com/konpa/devicon/raw/master/fonts/devicon.ttf && \
cd -
```

## Authors

**[Truong Ma Phi](https://github.com/trmaphi)**

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Credits to [sapegin](https://github.com/sapegin/dotfiles/tree/master/vscode) for his vscode setup
