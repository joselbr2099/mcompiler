MakeCommand("demo", "demo.demoCommand", 0)

function demoCommand()
    CurView():Save(false)
    runDemo()
end

function runDemo()
    local ft = CurView().Buf:FileType()
    local file = CurView().Buf.Path
    local dir = DirectoryName(file)
end
