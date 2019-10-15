                                      _ _           
      /\/\   ___ ___  _ __ ___  _ __ (_) | ___ _ __ 
     /    \ / __/ _ \| '_ ` _ \| '_ \| | |/ _ \ '__|
    / /\/\ \ (_| (_) | | | | | | |_) | | |  __/ |
    \/    \/\___\___/|_| |_| |_| .__/|_|_|\___|_|
                               |_|                  
    https://github.com/Odyssey2247/mcompiler

# Simple plugin to compile code using micro text editor V 1.0.1

### NOTE

this plugin is made for Tmux based IDE (t-ide) https://github.com/Odyssey2247/t-ide
but can be using without t-ide with the correct settings

### INSTALL

in micro open command mode (remember this: ctrl+e ) and:

	plugins install mcompiler

### MANUAL INSTALL

in terminal

    $ git clone https://github.com/Odyssey2247/mcompiler
    $ mv mcompiler ~/.config/micro/plugins

### USE
has 3 commands to use mcompiler:
to RUN your code(ruby, python...) open command mode and:

	>runc

to build/compile your code:
	
	>build

to debug your code:
	
	>debug

To configure these variables with your favorite language ruby example
open a terminal and: 

	>set runc ruby

to set "build" command, example go:

	>set build "go build -gcflags=-e"

remember that when using the prefix "set" the values passed to the commands
runc / build / debug will be local only for the current micro instance
to show current value of commad:

	>show build

Finally, to run/build/debug your code, you can use the micro command 
mode and use one of the 3 commands described above:

### KEYBINDINGS

to use a key instead of a command:

          "F5" command to build your code
          "F6" command to run your code

### CONFIG

open file:

	~/.config/micro/plugins/mcompiler/mcompiler.lua

to configure the commands "runc", "build" and "debug" in a global way for 
all the micro instances
