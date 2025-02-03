local system = {}

function system.reset(self) --cheap bad
    local new = self.init(self.rom, self.bootrom)
    return new
end

function system.init(bootrom, rom)
    system.rom = rom
    system.bootrom = bootrom
    system.ram = require("dmg.ram").init(bootrom, rom)
    system.cpu = require("dmg.cpu.cpu").init(system)
    system.ppu = require("dmg.ppu"):init(system)

    return system
end

return system