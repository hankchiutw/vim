fish_vi_key_bindings

set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x FZF_DEFAULT_OPTS "--bind ctrl-f:page-down,ctrl-b:page-up --history=$HOME/.fzf_history --exact"
# instead of using default `find` command which doesn't respect .gitignore
set -x FZF_DEFAULT_COMMAND "ag -l"

function fish_user_key_bindings
  for mode in insert default visual
    # Use ctrl+f to accept auto suggestion
    bind -M $mode \cf forward-char
    
    # Enable all Emacs mode key binding in vi mode
    # fish_default_key_bindings -M $mode
  end

  bind -M insert \cj 'commandline -f accept-autosuggestion; commandline -f execute'
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

function fish_prompt --description 'Write out the prompt'
  set -g fish_prompt_pwd_dir_length 80

  set -l ps_branch (__ps_branch)
  set -l ps_user (set_color yellow)(echo {$USER} | cut -c -4)@(hostname | cut -c -3)
  set -l ps_pwd (set_color blue)(prompt_pwd)
  set -l suffix (set_color normal)➝' '

  printf "$ps_branch$ps_user $ps_pwd $suffix"
end

function fish_right_prompt -d "Write out the right prompt"
    date '+%Y-%m-%d %H:%M:%S'
end

# remove the welcom message
function fish_greeting
end 
