                                      _ _           
      /\/\   ___ ___  _ __ ___  _ __ (_) | ___ _ __ 
     /    \ / __/ _ \| '_ ` _ \| '_ \| | |/ _ \ '__|
    / /\/\ \ (_| (_) | | | | | | |_) | | |  __/ |
    \/    \/\___\___/|_| |_| |_| .__/|_|_|\___|_|
                               |_|                  

Simple plugin to compile code using micro text editor

1.- INSTALL
in micro open command mode (ctrl+e) and type:

	plugins install mcompiler

2.- USE
to RUN your code(ruby, python...) open command mode an type:

	runc

to build/compile your code type
	
	build

3.- KEYBINDINGS
to use a key instead of a command (like F5 to build) go to the directory:
	
	cd ~/.config/micro

and create the file "bindings.json" with the following content
	
        {
          "F5": "command:build",
          "F6": "command:runc"
        }

and save.
in micro simple, press F5 to build your code or F6 to run

4.- CONFIG
open file:

	~/.config/micro/plugins/mcompiler/mcompiler.lua

to config "runc" and "buld" command to adjust your preferred language and 
build/compile/run options or add more commands
