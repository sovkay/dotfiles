if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source

function launch
	kitty --start-as=fullscreen --session ~/.config/kitty/mm.conf &
end
