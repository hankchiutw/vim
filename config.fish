fish_vi_key_bindings

set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK 1
set -x EDITOR nvim

set -x FZF_DEFAULT_OPTS "--bind 'ctrl-f:page-down,ctrl-b:page-up,tab:toggle-preview' --history=$HOME/.fzf_history --exact --color hl:217,hl+:87,fg+:11 --preview 'cat -n {}' --preview-window up:60%"
# instead of using default `find` command which doesn't respect .gitignore
set -x FZF_DEFAULT_COMMAND "ag -l"
set -x FZF_ALT_C_OPTS "--preview-window hidden --no-exact"
set -x FZF_CTRL_T_OPTS "--height 100%"

function f -d "fzf-cd-widget"
  fzf-cd-widget
end

set -x NNN_FIFO "/tmp/nnn.fifo"
set -x NNN_PLUG "p:preview-tui"

# Setup pyenv shims
if command -v pyenv 1>/dev/null 2>&1
  pyenv init --path | source
end

set -x VIRTUAL_ENV_DISABLE_PROMPT 1
function venv_activate --on-variable PWD --on-event fish_prompt
    if test ! -e pyproject.toml
        if test -n "$VIRTUAL_ENV"
            deactivate
        end
        return
    end

    # echo "Found pyproject.toml"
    if test ! -d .venv
        # echo "Creating $(python -V) venv"
        python -m venv .venv --prompt (basename (pwd))
    end

    source .venv/bin/activate.fish
end

# Fix "top" command issue when ssh to a remote
# See https://wiki.archlinux.org/title/Kitty#Terminal_issues_with_SSH
if test "$TERM" = "xterm-kitty"
  alias ssh="kitty +kitten ssh"
end

function fish_user_key_bindings
  for mode in insert default visual
    # Use ctrl+f to accept auto suggestion
    bind -M $mode \cf forward-char
    
    # Enable all Emacs mode key binding in vi mode
    # fish_default_key_bindings -M $mode
  end

  bind -M insert \cj 'commandline -f accept-autosuggestion; commandline -f execute'
  fzf_key_bindings
end

function __mode_color
  set -l color
  switch $fish_bind_mode
    case default
      set color red
    case insert
      set color blue
    case replace_one
      set color green
    case visual
      set color magenta
  end
  echo $color
end

function fish_mode_prompt
  set -l mode
  switch $fish_bind_mode
    case default
      set mode '🅽'
    case insert
      set mode '🅸'
    case replace_one
      set mode '🆁'
    case visual
      set mode '🆅'
  end

  set_color (__mode_color)
  echo -n "$mode "

  set_color normal
end

function __ps_branch
  set -g __fish_git_prompt_showupstream verbose
  set -g __fish_git_prompt_char_upstream_ahead ↑
  set -g __fish_git_prompt_char_upstream_behind ↓
  set -g __fish_git_prompt_char_upstream_diverged ⥮
  set -g __fish_git_prompt_showdirtystate 1
  set -g __fish_git_prompt_char_dirtystate ✚
  set -g __fish_git_prompt_showcolorhints 1

  set -l ps_branch (fish_vcs_prompt '  %s')
  if test -n "$ps_branch"
    set ps_branch (set_color green)$ps_branch "\n"(set_color blue)"╰─ "(set_color normal)
  end

  echo $ps_branch
end

function __ps_venv
  if test "$VIRTUAL_ENV"
    echo (set_color brmagenta)" "
  end
end

function fish_prompt --description 'Write out the prompt'
  set -g fish_prompt_pwd_dir_length 80

  set -l ps_venv (__ps_venv)
  set -l ps_branch (__ps_branch)
  set -l ps_user (set_color yellow)(echo {$USER} | cut -c -4)@(hostname | cut -c -3)
  set -l ps_pwd (set_color blue)(prompt_pwd)
  set -l suffix (set_color normal)➝' '

  printf "$ps_venv$ps_branch$ps_user $ps_pwd $suffix"
end

function fish_right_prompt -d "Write out the right prompt"
    date '+%Y-%m-%d %H:%M:%S'
end

# remove the welcom message
function fish_greeting
end 

function n --wraps nnn --description 'support nnn quit and change directory'
  # Block nesting of nnn in subshells
  if test -n "$NNNLVL"
    if [ (expr $NNNLVL + 0) -ge 1 ]
      echo "nnn is already running"
      return
      end
  end

  # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
  # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
  # see. To cd on quit only on ^G, remove the "-x" from both lines below,
  # without changing the paths.
  if test -n "$XDG_CONFIG_HOME"
    set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
  else
    set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
  end

  # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
  # stty start undef
  # stty stop undef
  # stty lwrap undef
  # stty lnext undef

  nnn $argv

  if test -e $NNN_TMPFILE
    source $NNN_TMPFILE
    rm $NNN_TMPFILE
  end
end
