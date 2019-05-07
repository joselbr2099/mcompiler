VERSION = "1.0.1"

--[[-CONFIG VARS---------------------------------------------------------------------]]--

--[[

    "runn" this variable is responsible for running the program/script, you can use any interpreter/compiler etc
    examples:
    runn = "go run"
    runn = "python"	
]]--

  runn = "python"         -- compiler/interpreter params, change this for custom param

--[[

    "comp" this variable is responsible for the flags or compilation arguments
    examples:
    comp = "go build -gcflags=-e"
]]--

  comp = "go build -gcflags=-e"  -- compiler/interpreter params, change this for custom param

--[[
    "bug" use this variable for your favorite debugger
    examples:
    comp = "gdb -d $(go env GOROOT) foo"
]]--

  bug =""

--[[

    "tide": "yes" if yo use Tmux based Ide (https://github.com/Odyssey2247/t-ide) 
            "no" for execution/compilation in background (no tide) use only micro
            default "no" 	
]]--

  tide="yes"

--[[-END CONFIG VARS-----------------------------------------------------------------]]--
if GetOption("runc") == nil then
    AddOption("runc", true)
end

if GetOption("build") == nil then
    AddOption("build", true)
end

if GetOption("debug") == nil then
    AddOption("debug", true)
end

MakeCommand("runc", "mcompiler.run_command", 0)
MakeCommand("build", "mcompiler.build_command", 0)
MakeCommand("debug", "mcompiler.debug_command", 0)

--function to run code
function run_command()
    print_term(runn,"run")
end

--function to compile code
function build_command()
    print_term(comp,"build")
end

--function to debug code
function debug_command()  
    print_term(bug,"debugger")
end

function print_term(cmd,type)
   CurView():Save(false)   -- save current open file
   local ft = CurView().Buf:FileType()   -- get file extension  
   local file = CurView().Buf.Path       -- get file name
   local dir = DirectoryName(file)       -- get directory of file
   local f = io.popen(cmd.." "..file..' 2>&1 && echo " $?"')  --execute cmd
   if(tide=="yes")
   then
	   os.execute("tmux send-keys -t 2 'Escape'")
	   os.execute("tmux run-shell -t 2 'echo ------------------Init-" .. type .. "------------------' ")
	   os.execute("tmux run-shell -t 2 'echo COMMAND_USE: "..cmd.." "..file.."'")	   
	    for line in f:lines() do	    
	      if line == " 0"
	      then
                 os.execute("tmux run-shell -t 2 'echo ALL_OK_NO_ERRORS' ")
                 os.execute("tmux run-shell -t 2 'echo EXEC_CODE: " .. line .. "' ")
              else
                 os.execute("tmux run-shell -t 2 'echo " .. line .. "' ")  --print in tmux pane 2
	      end
	    end
	   os.execute("tmux run-shell -t 2 'echo ------------------Finish-" .. type .. "----------------' ")
   else
       local out = f:read('*all')
       local err = RunInteractiveShell("clear",false,false)
			if err1 ~=nil then
				 messenger:Error(err)
		    end
       local err1 = RunInteractiveShell("echo "..out,true,true)
	        if err1 ~=nil then
	            messenger:Error(err)
	        end
   end	          
   f:close()
   --os.execute("tmux send-keys -t 2 'PageDown'")   
end