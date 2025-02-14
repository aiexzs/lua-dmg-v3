local ramMod = {}

local bit = require('bit')

local fileStub = {
    read = function(a)
        return(string.char(0x00))
    end,
    seek = function(a,b) end
}

function ramMod.init(bootrom, rom)
    rom = rom and rom or fileStub
    local ram = {}
    ram.mem = {}
    for i = 0, 0x00ff do --first 256 bytes are bootrom
        bootrom:seek(i)
        ram.mem[i] = {}
        ram.mem[i][1] = bootrom:read(1):byte() or 0xff --data
        ram.mem[i][2] = false                       --write access
    end

    for i = 0x0100, 0x3fff do --read-only rom bank, cannot be switched
        rom:seek(i)
        ram.mem[i] = {}
        ram.mem[i][1] = rom:read(1):byte() or 0xff
        ram.mem[i][2] = false
    end

    for i = 0x4000, 0x7fff do --r/w rom bank, can be switched
        rom:seek(i)
        ram.mem[i] = {}
        ram.mem[i][1] = rom:read(1):byte() or 0xff
        ram.mem[i][2] = true
    end

    for i = 0x8000, 0xffff do --everything else, i don't really care about the unused/unmapped areas for now (TODO because it's used for copy protection in some instances)
        ram.mem[i] = {}
        ram.mem[i][1] = 0x00--math.random(255)
        ram.mem[i][2] = true
    end

    --fancy schmancy stuff that lets you index this like a normal table but with the permissions intact
    ram.__index = function(table, key)
        key = key % 0xffff
        --print("retrieved "..bit.tohex(key, 4)..": "..bit.tohex(table.mem[key][1], 2))
        return table.mem[key][1] --return the data from index 1 instead of the entire nested table of permissions and shit, 
    end                          --so you only need to do system.cpu.ram[0x0000] instead of system.cpu.ram[0x0000][1]

    ram.__newindex = function(table, key, val)
        key = key % 0xffff
        if table.mem[key] then --check nil (this should never == false)
            if val then
                if table.mem[key][2] then --can i write to this address?
                    table.mem[key][1] = val % 256 --between 0x00 and 0xff
                    --print("wrote "..bit.tohex(key,4)..": "..bit.tohex(val,2))
                else
                    print("illegal write @ 0x"..bit.tohex(key,4)..", could not write "..bit.tohex(val,2)) --doodie fart
                end
            end
        end
    end

    setmetatable(ram, ram)

    return ram
end

return ramMod