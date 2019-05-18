VERSION = "1.0.1"

--[[-CONFIG VARS---------------------------------------------------------------------]]--

--[[

    "runc" this variable is responsible for running the program/script, you can use any interpreter/compiler etc
    examples:
    runn = "go run"
    runn = "python"	
]]--
  -- compiler/interpreter params, change this for custom param
  runc = ""

--[[

    "build" this variable is responsible for the flags or compilation arguments
    examples:
    comp = "go build -gcflags=-e"
]]--
  -- compiler/interpreter params, change this for custom param
  build = ""

--[[
    "debug" use this variable for your favorite debugger
    examples:
    comp = "gdb -d $(go env GOROOT) foo"
]]--

  debug =""

--[[
    "folder": "yes" to compile from the current folder instead of a file 
              "no"  to compile from the current file   
              default "no"
]]--

  folder ="no"

--[[

    "tide": "yes" if yo use Tmux based Ide (https://github.com/Odyssey2247/t-ide) 
            "no" for execution/compilation in background (no tide) use only micro
            default "no" 	
]]--

  tide="no"

--[[-END CONFIG VARS-----------------------------------------------------------------]]--
--[[-CONFIG OPTIONS------------------------------------------------------------------]]--
-- add custom options for commands:

AddOption("runc", runc)
AddOption("build", build)
AddOption("debug", debug)
AddOption("folder", folder)

--[[-CONFIG OPTIONS------------------------------------------------------------------]]--
--make commands
MakeCommand("runc", "mcompiler.run_command", 0)
MakeCommand("build", "mcompiler.build_command", 0)
MakeCommand("debug", "mcompiler.debug_command", 0)
--bindkeys
BindKey("F5", "mcompiler.run_command")
BindKey("F6", "mcompiler.build_command")
BindKey("F8", "mcompiler.debug_command")
BindKey("F9", "mcompiler.tree_command")

--function to run code
function run_command()
       command("runc")

end

--function to compile code
function build_command()
        command("build")

end

--function to debug code
function debug_command()
        command("debug")  
end

--function to open file manager
function tree_command()
  HandleCommand("tree")   
end

function command(arg)
if tide =="yes"
  then
       loadConf()
       if GetOption(arg) == "" 
	  then
	       help(arg)
	  else
	       print_term(GetOption(arg),arg)	
       end
  else
       if GetOption(arg) == "" 
          then
	       RunShellCommand("clear")
	       RunInteractiveShell(help(arg),true,true)
          else
	       print_term(GetOption(arg),arg)	
       end
end    
end

function print_term(cmd,type) 
   CurView():Save(false)   -- save current open file
   local ft = CurView().Buf:FileType()   -- get file extension  
   local file = CurView().Buf.Path       -- get file name
   local dir = DirectoryName(file)       -- get directory of file
   if(tide=="yes")
   then	
 	 if GetOption("folder") == "no"
	     then
	          opt=file
	          running='"'.."cd "..dir.." && "..cmd.." "..file..' 2>&1'..'"'	
	     else
	          opt=dir
	          running='"'.."cd "..dir.." && "..cmd.." "..dir..' 2>&1'..'"'
   	 end
         os.execute("tmux send-keys -t 2 'SES=$(tmux display-message -p "..'"'.."#S"..'"'..")' ENTER")
	 os.execute("tmux send-keys -t 2 'sh ~/.config/t-ide/$SES/builder "..("%q"):format(cmd).." "..("%q"):format(opt).." "..("%q"):format(type).." "..running.."' ENTER")  
   else 
	if GetOption("folder") == "no"
	    then
	         f = io.popen("cd "..dir.." && "..cmd.." "..file..' 2>&1 && echo " $?"')  --execute cmd
	         opt=file	
	    else
	         f = io.popen("cd "..dir.." && "..cmd.." "..dir..' 2>&1 && echo " $?"')  --execute cmd
	         opt=dir
        end
	RunShellCommand("clear")
	n = os.tmpname()
        file=io.open(n,"w")
        file:write("\n")
        file:write("------------------Init-" .. type .. "------------------ ","\n")
        file:write("COMMAND_USE: " .. tostring(cmd) .. " " .. tostring(opt),"\n")
	file:write("\n")	
        for line in f:lines() do
           if line == " 0"
             then
		file:write("\n")
		file:write("ALL_OK_NO_ERRORS ","\n")
		file:write("EXEC_CODE:" .. line .. " ","\n")
             else
		file:write(line,"\n")
           end          
        end
        file:write("------------------Finish-" .. type .. "---------------- ","\n")
	file:close()
	RunInteractiveShell("cat "..n.."",true,true)
        os.remove(n)
        f:close()     
   end	          

   --os.execute("tmux send-keys -t 2 'PageDown'")   
end
function help(cmd)
if tide=="yes"
   then
       os.execute("tmux send-keys -t 2 'Escape'")
       os.execute("tmux run-shell -t 2 'echo ------------------Error-" .. cmd .. "------------------' ")
       os.execute("tmux run-shell -t 2 'echo COMMAND: "..cmd.." is empty'")
       os.execute("tmux run-shell -t 2 'echo please config the command in -build options- window '")
       os.execute("tmux run-shell -t 2 'echo or view README from tide'")
       os.execute("tmux run-shell -t 2 'echo '")
       os.execute("tmux run-shell -t 2 'echo mcompiler v1.0.1'")
       os.execute("tmux run-shell -t 2 'echo https://github.com/Odyssey2247/mcompiler'")
       os.execute("tmux run-shell -t 2 'echo ------------------Error-" .. cmd .. "------------------' ")		
   else
       RunInteractiveShell("clear",false,false)
       hlp="echo -e 'Mcompiler v1.0.1\n".. 
           "https://github.com/Odyssey2247/mcompiler\n"..
           "\n"..
           "Error the variable -"..cmd.."- is not set\n"..
           " Please use te following commands to set your variables:\n"..
           " -runc,\n".. 
           " -build,\n".. 
           " -bug,\n"..
           " open command mode in micro (ctrl+e) an hit:\n"..
           "\n"..
           " use the 'set' command to set the 'option' variable globally\n"..
           " for all micro instances:\n"..
           " >set <option>\n"..
           "\n"..
           " for current instace only\n"..
           " >setlocal <option>\n"..    
           " \n"..
           " for run only (example python):\n"..
           " >set run python\n"..
           "\n"..
           " to build your code with custom arguments (example go):\n"..
           ' >set build "go build -gcflags=-e"\n'..
           "\n"..
           ' remember use " " for arguments that have spaces\n'..
           " to see the current value of the variable\n"..
           "\n"..  
           " >show <var>\n"..
           "\n' "
       return hlp
end
end

function loadConf()
  session=io.popen("tmux display-message -p '#S'")
  profile=session:read('*l')
  dofile(os.getenv('HOME').."/.config/t-ide/"..profile.."/"..profile..".lua")
  session:close()
end
