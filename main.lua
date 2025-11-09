local ffi = require "ffi"
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end



local debug_output = io.open("output.txt", "w+")

_G.colors = require("ansicolors") --thx
--_G.print = function(str) debug_output:write(tostring(str).."\n") end
_G.print = function() end

local system
local bootrom = love.filesystem.newFile("bootrom-intact.gb", "r")
local rom = love.filesystem.newFile("test-roms/mooneye-test-suite/manual-only/sprite_priority.gb", "r")
local imgui = require("cimgui")

function love.load()
    system = require("dmg.system").init(bootrom, rom)
    love.graphics.setPointSize(3)

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
local scrollWheel = 0

local val = ffi.new("float[1]")
local fart = {255, 255, 255, 255, 255, 255, 255, 255}


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

    imgui.Begin("test")

    
    imgui.SliderFloat("hi", val, 0.0, 10.0)
    for i,v in pairs(fart) do
        local strbuf = ffi.new("char[2]")
        ffi.copy(strbuf, bit.tohex(v, 2), 2)
        imgui.SetNextItemWidth(50)
        imgui.PushID_Int(i^2)
        if imgui.InputText(" ", strbuf, 3, bit.bor(imgui.ImGuiInputTextFlags_CharsUppercase, imgui.ImGuiInputTextFlags_CharsHexadecimal, imgui.ImGuiInputTextFlags_EnterReturnsTrue)) then
            v = tonumber(ffi.string(strbuf, 2), 16)
        end
        imgui.PopID()
        imgui.SameLine()
    end


    
    imgui.End()


    scrollWheel = 0

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
    scrollWheel = scrollWheel + y
    imgui.love.WheelMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end
