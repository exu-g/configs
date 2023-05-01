#vi mode for fish
#fish_vi_key_bindings
fish_default_key_bindings

# change greeting
set fish_greeting "Good Morning! Nice day for fishing ain't it! Hu ha!"

# Info:
# https://fishshell.com/docs/current/index.html#variables-for-changing-highlighting-colors
set fish_color_normal blue
set fish_color_command blue
set fish_color_quote bryellow
set fish_color_redirection
set fish_color_end brred
set fish_color_error red
set fish_color_param brblue
set fish_color_comment white
set fish_color_selection brcyan
set fish_color_search_match magenta
set fish_color_operator blue
set fish_color_escape green
set fish_color_autosuggestion brwhite
set fish_color_host_remote brwhite
set fish_color_cancel brred

# used in prompt
set fish_color_user --bold red
set fish_color_separator --bold yellow
set fish_color_host cyan
set fish_color_cwd yellow

# environment variables
# SSH Agent
set SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"
export SSH_AUTH_SOCK
# text editor
set EDITOR nvim
set VISUAL nvim
