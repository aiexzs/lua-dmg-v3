local ffi = require "ffi"
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end



local debug_output = io.open("output.txt", "w+")

_G.colors = require("ansicolors") --thx
--_G.print = function(str) debug_output:write(tostring(str).."\n") end
--_G.print = function() end

local last_print = ""
_G.print = function(str) last_print = tostring(str) end 

local system
local bootrom = love.filesystem.newFile("dmg_boot.bin", "r")
local rom = love.filesystem.newFile("Tetris.gb", "r")
local imgui = require("cimgui")

function love.load()
    system = require("dmg.system").init(bootrom, rom)
    love.graphics.setPointSize(3)

    local pixelScale = love.window.getDPIScale()
    love.window.setMode(800*2, 600*2)

    imgui.love.Init()
    
end

local function clamp(x, min, max)
    if x < min then return min elseif x > max then return max else return x end
end

local cpuClocks = 0
local ppuClocks = 0
local clock = 1
local update = true
function love.update(dt)
    clock = (4100000 * (1/60))/4
    if update then
        for i = 1, clock do
            if cpuClocks < 4 then
                system.cpu:tick()
                cpuClocks = cpuClocks + 1
            end

            if ppuClocks < 1 then
                system.ppu:tick()
                ppuClocks = ppuClocks + 1
            end

            if cpuClocks == 4 and ppuClocks == 1 then
                cpuClocks = 0
                ppuClocks = 0
            end
        end
    end

    imgui.love.Update(dt)
    imgui.NewFrame()
end

local showHexEditor = false
local hexEditorScroll = 0
local scrollWheel = ffi.new("int[4]", {0})

function love.draw()
    --screen
    for x = 1, 160 do
        for y = 1, 144 do
            local pixel = system.ppu.screen[x][y] or 0
            local shade = ((3-pixel)/3)/1.5
            love.graphics.setColor(shade,shade*1.25,shade)
            love.graphics.points((x*3)+100, (y*3)+100)
        end
    end
    love.graphics.setColor(1,1,1,1)

    love.graphics.print("pc: 0x"..bit.tohex(system.cpu.registers.pc, 4))

    imgui.Begin("Debug") -- MAIN DEBUG STUFF START
    
    imgui.Text("FPS: %d", love.timer.getFPS())
    imgui.Text("PC: ")
    imgui.SameLine()
    imgui.SetNextItemWidth(36)
    local pcbuf = ffi.new("char[5]")
    ffi.copy(pcbuf, bit.tohex(system.cpu.registers.pc, 4))

    if imgui.InputText(" ", pcbuf, 5, bit.bor(imgui.ImGuiInputTextFlags_CharsUppercase, imgui.ImGuiInputTextFlags_CharsHexadecimal, imgui.ImGuiInputTextFlags_EnterReturnsTrue)) then
        system.cpu.registers.pc = tonumber(ffi.string(pcbuf, 4), 16)
    end

    --prepare for a mess 
    imgui.Text("8-bit Registers\nA: %s\tB: %s\nC: %s\tD: %s\nE: %s\tF: %s\nH: %s\tL: %s", bit.tohex(system.cpu.registers.a, 2), bit.tohex(system.cpu.registers.b, 2), bit.tohex(system.cpu.registers.c, 2), bit.tohex(system.cpu.registers.d, 2), bit.tohex(system.cpu.registers.e, 2), bit.tohex(system.cpu.registers.f, 2), bit.tohex(system.cpu.registers.h, 2), bit.tohex(system.cpu.registers.l, 2))
    imgui.Text("16-bit Registers\nAF: %s\tBC: %s\nDE: %s\tHL: %s", bit.tohex(system.cpu.registers:get_af(), 4), bit.tohex(system.cpu.registers:get_bc(), 4), bit.tohex(system.cpu.registers:get_de(), 4), bit.tohex(system.cpu.registers:get_hl(), 4))
    imgui.Text("Current cycle counter: %s", tostring(system.cpu.cycles))
    imgui.Text("CPU Msg: %s", system.cpu.message)

    --update checkbox
    local updBuf = ffi.new("bool[1]", {update})
    imgui.Checkbox("Update", updBuf)
    update = updBuf[0]

    --tick the cpu
    if imgui.Button("Tick 1x") then
        system.cpu:tick()
    end

    imgui.SameLine()
    if imgui.Button("10x") then
        for i = 1, 10 do
            system.cpu:tick()
        end
    end
    imgui.SameLine()
    if imgui.Button("100x") then
        for i = 1, 100 do
            system.cpu:tick()
        end
    end
    imgui.SameLine()
    if imgui.Button("1000x") then
        for i = 1, 1000 do
            system.cpu:tick()
        end
    end
    imgui.SameLine()
    if imgui.Button("10000x") then
        for i = 1, 10000 do
            system.cpu:tick()
        end
    end

    if imgui.Button("PC++") then
        system.cpu.registers.pc = system.cpu.registers.pc + 1
    end

    if imgui.Button("Reset") then --you have to click this twice for some reason
        system:reset()
    end

    --bypass memory r/w restrictions toggle
    local bypassBuf = ffi.new("bool[1]", {system.ram.bypass})
    imgui.Checkbox("Bypass RAM W/P", bypassBuf)
    system.ram.bypass = bypassBuf[0]

    imgui.Text(last_print)

    imgui.End() -- MAIN DEBUG STUFF END

    imgui.Begin("Hex Editor") -- HEX EDITOR START

    imgui.PushStyleVar_Vec2(imgui.ImGuiStyleVar_ItemSpacing, imgui.ImVec2_Float(-10, 1)) -- set padding to make a grid
    imgui.PushStyleVar_Vec2(imgui.ImGuiStyleVar_FramePadding, imgui.ImVec2_Float(2, 2))

    for rows = 0, 15 do
        imgui.TextUnformatted(bit.tohex(hexEditorScroll+(0x10*rows), 4))
        imgui.SameLine(0, 0)

        for cols = 0, 15 do --hex section
            local currentPos = bit.band(hexEditorScroll, 0xFFF0) + ((rows*16)+cols)
        
            local strbuf = ffi.new("char[3]") -- 2 bytes for 2 hex characters and a third for the terminator otherwise you get garbage data
            ffi.copy(strbuf, bit.tohex(system.ram[currentPos], 2), 2) --copy the value (converted to string) from ram to our string buffer

            imgui.SetNextItemWidth(18)
            imgui.PushID_Int(currentPos)
            if imgui.InputText(" ", strbuf, 3, bit.bor(imgui.ImGuiInputTextFlags_CharsUppercase, imgui.ImGuiInputTextFlags_CharsHexadecimal, imgui.ImGuiInputTextFlags_EnterReturnsTrue)) then
                system.ram[currentPos] = tonumber(ffi.string(strbuf, 2), 16) -- when user presses enter, set the byte at the address [[TODO]] make it work
            end

            imgui.PopID()
            imgui.SameLine()
        end
        
        local line = "|"
        for i = 1, 16 do -- utf8 generator for this row
            local char = string.char(system.ram[(hexEditorScroll+rows*16)+i])
            local newchar = string.match(char, "[%p%a%d%s]") and char or "." --use only punctuation, letters, space because non-ASCII characters have weird spacing sometimes
            line = line..""..newchar
        end
        imgui.TextUnformatted(line)

        --imgui.NewLine()
    end

    imgui.PopStyleVar(2)

    --scroll wheel behavior
    imgui.SliderInt('Scroll', scrollWheel, -4, 4)
    
    if imgui.IsWindowHovered() then
        hexEditorScroll = hexEditorScroll + (scrollWheel[0] * (0x10))
    end
    scrollWheel[0] = 0

    --jump to address
    local jumpBuf = ffi.new("char[5]")
    ffi.copy(jumpBuf, bit.tohex(hexEditorScroll, 4))
    if imgui.InputText("Jump to Address", jumpBuf, 5, bit.bor(imgui.ImGuiInputTextFlags_CharsUppercase, imgui.ImGuiInputTextFlags_CharsHexadecimal, imgui.ImGuiInputTextFlags_EnterReturnsTrue)) then
        hexEditorScroll = tonumber(ffi.string(jumpBuf, 4), 16)
    end

    imgui.End() --HEX EDITOR END


    imgui.Render()
    imgui.love.RenderDrawLists()
end

function love.quit()
    imgui.love.Shutdown()
end


--
-- User inputs (imgui hooks)
--
function love.textinput(t)
    imgui.love.TextInput(t)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keypressed(key)
    imgui.love.KeyPressed(key)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keyreleased(key)
    imgui.love.KeyReleased(key)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.mousemoved(x, y)
    imgui.love.MouseMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousepressed(x, y, button)
    imgui.love.MousePressed(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousereleased(x, y, button)
    imgui.love.MouseReleased(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.wheelmoved(x, y)
    imgui.love.WheelMoved(x, y)
    scrollWheel[0] = scrollWheel[0] - y
    if not imgui.love.GetWantCaptureMouse() then
    end
end
