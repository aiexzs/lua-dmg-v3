if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end



local debug_output = io.open("output.txt", "w+")

_G.colors = require("ansicolors") --thx
--_G.print = function(str) debug_output:write(tostring(str).."\n") end

local system
local bootrom = io.open("sgb2_boot.bin", "r")
local rom = io.open("test-roms/mooneye-test-suite/manual-only/sprite_priority.gb", "r")
local imgui = require("imgui")

function love.load()
    system = require("dmg.system").init(bootrom, rom)
    love.graphics.setPointSize(3)
end

local function clamp(x, min, max)
    if x < min then return min elseif x > max then return max else return x end
end

local cpuClocks = 0
local ppuClocks = 0
local clock = 1
local update = false
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

    imgui.NewFrame()
end

local showHexEditor = false
local hexEditorScroll = 0
local scrollWheel = 0
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
    love.graphics.setColor(1,1,1)

    if imgui.BeginMainMenuBar() then
        if imgui.Button("Hex Editor") then
            showHexEditor = not showHexEditor
        end
        imgui.EndMainMenuBar()
    end

    -- imgui ram viewer
    if showHexEditor then
        imgui.SetNextWindowSize(650, 425)
        imgui.Begin("   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F") -- guh,,,,

        local flooredScroll = math.floor(hexEditorScroll)
        local scrollStepped = bit.band(flooredScroll, 0xFFF0)

        for i = scrollStepped, scrollStepped+(0x0010*19), 0x0010 do --loop for 19 rows following the initial scroll value
            i = i % 0xffff
            local line = tostring(bit.tohex(i,4))
            local bytes = {}
            for l = 0x00, 0x0F do
                local index = i+l+math.floor(i/0xfff0)
                local value = system.cpu.ram[index]
                bytes[l] = value
                line = line.." "..bit.tohex(value, 2)
            end
            
            line = line.." |"

            for c = 1, #bytes do
                local char = bytes[c]
                line = line.." "..((string.match(string.char(bytes[c]), "%g") ~= nil) and string.char((bytes[c])) or ".")
            end
            imgui.TextUnformatted(line)
        end

        hexEditorScroll = clamp(hexEditorScroll + (imgui.SliderFloat("Scroll", 0, -10, 10)*0x0010), 0, 0xffff)

        if imgui.IsWindowHovered() then
            if scrollWheel ~= 0 then
                hexEditorScroll = hexEditorScroll + -scrollWheel*0x10
            end
        end

        local scrstr, isnew = imgui.InputText("Scroll to", bit.tohex(flooredScroll,4), 5)

        if isnew then
            scrstr = scrstr or "ffff"
            hexEditorScroll = (tonumber(scrstr, 16) or 0) % 0xffff
        end

        imgui.End()
    end

    --imgui debug shit
    imgui.SetNextWindowSize(500, 400)
    imgui.Begin("Debug")
    clock = imgui.InputInt("Clock", clock)
    update = imgui.Checkbox("Update", update)
    --updateppu = imgui.Checkbox("Update cpu.ppu", updateppu)
    --rate = imgui.InputInt(tostring("Rate (Hz), actual: "..totalCycles), rate)
    if imgui.Button("Step") then
        system.cpu:tick()
    end
    if imgui.Button("Reset") then
        update = false
        system.cpu = nil
        system.ram = nil
        system = nil
        system = require("dmg.system").init(bootrom, rom)
        system.cpu.registers.pc = 0
        local regs = {'a', 'b', 'c', 'd', 'e', 'f', 'h', 'l'}
        for i,v in pairs(regs) do
            system.cpu.registers[v] = 0
        end
    end
    imgui.Text(tostring("FPS: "..love.timer.getFPS().."\nA:"..bit.tohex(system.cpu.registers.a, 2).." \nB:"..bit.tohex(system.cpu.registers.b, 2).." \nC:"..bit.tohex(system.cpu.registers.c, 2).." \nD:"..bit.tohex(system.cpu.registers.d, 2).." \nE:"..bit.tohex(system.cpu.registers.e, 2).." \nF:"..bit.tohex(system.cpu.registers.f, 2).." \nH:"..bit.tohex(system.cpu.registers.h, 2).." \nL:"..bit.tohex(system.cpu.registers.l, 2).." \nSP: "..bit.tohex(system.cpu.registers.sp,4).." \nPC: "..bit.tohex(system.cpu.registers.pc+1, 6).."\nscy: "..tostring(system.ram[0xff42]).."\nscx: "..tostring(system.ram[0xff43])))
    for i,v in pairs({'z', 'n', 'hc', 'c'}) do
        local value = tostring(system.cpu.registers:get_flag(v) and 1 or 0)
        imgui.Text("flag "..v..": "..value)
    end
    if imgui.Button("+ PC") then
        system.cpu.registers.pc = system.cpu.registers.pc + 1
    end
    --imgui.Text(tostring("Z: "..tostring(system.cpu.registers.zero)).."\nS:"..tostring(system.cpu.registers.subtract).."\nC: "..tostring(system.cpu.registers.carry).."\nHC: "..tostring(system.cpu.registers.half_carry))
    imgui.End()

    scrollWheel = 0
    imgui.Render()
end

function love.quit()
    imgui.ShutDown()
end


--
-- User inputs (imgui hooks)
--
function love.textinput(t)
    imgui.TextInput(t)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keypressed(key)
    imgui.KeyPressed(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.keyreleased(key)
    imgui.KeyReleased(key)
    if not imgui.GetWantCaptureKeyboard() then
        -- Pass event to the game
    end
end

function love.mousemoved(x, y)
    imgui.MouseMoved(x, y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousepressed(x, y, button)
    imgui.MousePressed(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.mousereleased(x, y, button)
    imgui.MouseReleased(button)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end

function love.wheelmoved(x, y)
    scrollWheel = scrollWheel + y
    imgui.WheelMoved(y)
    if not imgui.GetWantCaptureMouse() then
        -- Pass event to the game
    end
end
