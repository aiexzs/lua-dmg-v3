--this script links all of the system components together in a way that they can talk to each other without too much junk

local system = {}

function system.reset(self) --cheap bad no good but we'll have to live with it for now
    local new = system.init(self.rom, self.bootrom)
    self = nil
    new.cpu.registers.pc = 0
    return new
end

function system.step_mcycle(self) -- also think of this as the main system clock/4 rather than an "m-cycle" (despite the name still being accurate)
    self.cpu:step()             -- in other words, this function/module owns and controls the time that the components consume during each m-cycle (4 t-cycles)
    self.cycle = self.cycle + 1
end

function system.init(bootrom, rom)
    system.rom = rom
    system.bootrom = bootrom
    system.ram = require("dmg.ram").init(bootrom, rom, system)
    system.cpu = require("dmg.cpu.cpu").init(system)
    system.ppu = require("dmg.ppu"):init(system)

    system.cycle = 0
    return system
end

return system