--this script links all of the system components together in a way that they can talk to each other without too much junk

local system = {}

function system.reset(self) --cheap bad no good
    local new = system.init(self.rom, self.bootrom)
    self = nil
    new.cpu.registers.pc = 0
    return new
end

function system.init(bootrom, rom)
    system.rom = rom
    system.bootrom = bootrom
    system.ram = require("dmg.ram").init(bootrom, rom, system)
    system.cpu = require("dmg.cpu.cpu").init(system)
    system.ppu = require("dmg.ppu"):init(system)

    return system
end

return system