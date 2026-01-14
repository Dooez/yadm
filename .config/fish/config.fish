if status is-interactive
    # Commands to run in interactive sessions can go here
end
set fish_greeting
starship init fish | source

alias vi nvim
alias vim nvim
set -g EDITOR nvim
set -gx NVIM_ANIMATE 1
set -gx NVIM_DAP 1
set -gx NVIM_CORTEX_DBG 0


function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
