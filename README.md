# prezto-fzf

[fzf][fzf] integration for [Prezto][prezto], the Zsh configuration framework.
The module loads fzf's own zsh key bindings and completion (`fzf --zsh`) and
adds sensible defaults for file listing and for tmux.

- Fuzzy history search, file picker and directory jumper on
  <kbd>Ctrl</kbd> + <kbd>R</kbd>, <kbd>Ctrl</kbd> + <kbd>T</kbd> and
  <kbd>Alt</kbd> + <kbd>C</kbd>.
- Uses [fd][fd] for listings when installed, falling back to [ripgrep][rg].
- Opens fzf in a [tmux popup][fzf-popup] inside tmux.
- Does nothing if `fzf` is not installed.

## Requirements

- [Prezto][prezto]
- [fzf][fzf] 0.53 or newer. The module uses `fzf --zsh` (0.48) and `--tmux`
  (0.53).
- Optional: [fd][fd] or [ripgrep][rg] for faster, `.gitignore`-aware listings.
- Optional: [tmux][tmux] 3.3 or newer for the popup.

On Arch Linux:

```sh
sudo pacman -S fzf fd
```

See the [fzf installation instructions][fzf-install] for other systems.

## Installation

Prezto loads [external modules][prezto-external] from _`.zprezto/contrib`_, and
from any directory listed in the `pmodule-dirs` setting. The module directory
must be named `fzf`, because Prezto uses the directory name as the module name.

Pick one of the two options.

### Option 1: Prezto's `contrib` directory

Prezto's `.gitignore` ignores `contrib`, so the module does not show up in
`git status` or in updates of Prezto. A `git clean -fdX` in the Prezto
directory removes ignored files, and with them the module.

```sh
git clone https://github.com/tsachev/prezto-fzf.git \
  "${ZPREZTODIR:-${ZDOTDIR:-$HOME}/.zprezto}/contrib/fzf"
```

### Option 2: a separate directory

This keeps the module out of the Prezto directory completely. Add the directory
to _`${ZDOTDIR:-$HOME}/.zpreztorc`_:

```sh
git clone https://github.com/tsachev/prezto-fzf.git \
  "${ZDOTDIR:-$HOME}/.zprezto-contrib/fzf"
```

```sh
zstyle ':prezto:load' pmodule-dirs "${ZDOTDIR:-$HOME}/.zprezto-contrib"
```

### Enable the module

Add `fzf` to the module list in _`${ZDOTDIR:-$HOME}/.zpreztorc`_, **after**
`editor`. Both modules bind <kbd>Ctrl</kbd> + <kbd>R</kbd>, and the module
loaded last wins.

```sh
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  ... \
  'fzf' \
  'prompt'
```

Open a new shell, or run `exec zsh`.

### Updating

```sh
git -C "<module directory>/fzf" pull
```

### If completion or key bindings do not appear

Prezto caches the completion scan in _`~/.cache/prezto/zcompdump`_ for 20 hours.
After installing `fzf`, delete the cache once and start a new shell:

```sh
rm ~/.cache/prezto/zcompdump* && exec zsh
```

## Key bindings

- <kbd>Ctrl</kbd> + <kbd>R</kbd> searches the command history.
- <kbd>Ctrl</kbd> + <kbd>T</kbd> pastes the selected files onto the command line.
- <kbd>Alt</kbd> + <kbd>C</kbd> changes into the selected directory.

## Rebinding keys

fzf replaces three zsh defaults:

| Key | Default | With fzf |
|---|---|---|
| <kbd>Ctrl</kbd> + <kbd>R</kbd> | `history-incremental-pattern-search-backward` (set by the `editor` module) | `fzf-history-widget` |
| <kbd>Ctrl</kbd> + <kbd>T</kbd> | `transpose-chars` | `fzf-file-widget` |
| <kbd>Alt</kbd> + <kbd>C</kbd> | `capitalize-word` | `fzf-cd-widget` |

If your muscle memory uses one of the defaults, put it back, or move the fzf
widget to another key. Add the lines you want after the module list is loaded
(for example at the end of _`${ZDOTDIR:-$HOME}/.zshrc`_):

```sh
# Built-in incremental history search on Alt+R
bindkey -M emacs '\er' history-incremental-pattern-search-backward

# Restore transpose-chars and capitalize-word, and move the fzf widgets
bindkey -M emacs '^T' transpose-chars
bindkey -M emacs '\ec' capitalize-word
bindkey -M emacs '^X^T' fzf-file-widget
bindkey -M emacs '\eo' fzf-cd-widget
```

Any fzf widget (`fzf-history-widget`, `fzf-file-widget`, `fzf-cd-widget`) can be
bound to any key. Check that a key is free with `bindkey -M emacs '<key>'`; it
prints `undefined-key` if it is.

## File listing

If `fd` is installed, the module sets these variables so that listings skip
hidden and `.gitignore`d files:

```sh
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d'
```

Without `fd`, `rg --files` is used for file listings if ripgrep is installed.
Otherwise fzf uses its built-in `find` based defaults. `fd` is preferred because
it was faster in a home folder benchmark (85 ms against 142 ms for about
324,000 files) and, unlike `rg`, can list directories for
<kbd>Alt</kbd> + <kbd>C</kbd>.

## tmux

Inside tmux (`$TMUX` is set), fzf opens in a centered popup (`--tmux`, needs
tmux 3.3 or newer). Outside tmux it uses a pane of 40% of the screen height. In
both cases the list is shown with the prompt at the top (`--layout=reverse`) and
a border. Options already set in `FZF_DEFAULT_OPTS` are kept.

To change the popup size, edit `--tmux center,80%,70%` in `init.zsh`. See the
fzf documentation for the [`--popup` options][fzf-popup].

## License

[MIT](LICENSE)

[prezto]: https://github.com/sorin-ionescu/prezto
[prezto-external]: https://github.com/sorin-ionescu/prezto#external-modules
[fzf]: https://github.com/junegunn/fzf
[fzf-install]: https://github.com/junegunn/fzf#installation
[fzf-popup]: https://github.com/junegunn/fzf#--popup-mode
[fd]: https://github.com/sharkdp/fd
[rg]: https://github.com/BurntSushi/ripgrep
[tmux]: https://github.com/tmux/tmux
