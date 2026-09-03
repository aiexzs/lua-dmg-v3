local cpu = {}
require("bit")
local instructions = require("dmg.cpu.instructions")

local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

cpu.registers = require("dmg.cpu.registers")

function cpu.init(system)
    io.write(colors("CPU Initializing, #instrs (non-cb): "..#instructions.."\n", "green"))
    local missing_instrs = {}
    for i = 1, 0xff do
        if not instructions[i] then
            missing_instrs[#missing_instrs+1] = bit.tohex(i, 2)
        end
    end
    print(missing_instrs)

    cpu.system = system
    cpu.ram = system.ram
    cpu.message = ""
    cpu.update = true
    cpu.current = {
        opcode = 0, -- we can just call it again instead of reading memory (essentially IR register)
        cycle = 0, -- in M-cycles, T-cycle accuracy is not implemented (not needed?)
        temp = 0 -- any persistent data we might need
    }
    cpu.halt = false
    return cpu
end

--pc/sp register r/w functions

function cpu.read_byte_pc(self)
    local pc = self.registers:get_register("pc")
    local byte = self.ram[pc+1]

    return byte
end

function cpu.read_byte_pc_up(self)
    local pc = self.registers:get_register("pc")
    local byte = self.ram[pc]
    self.registers:set_register("pc", pc + 1)

    return byte
end

function cpu.read_u16_pc_up(self)
    local lower = self:read_byte_pc_up()
    local upper = self:read_byte_pc_up()

    return bor(lshift(upper, 8), lower)
end

function cpu.read_byte_sp_up(self)
    local sp = self.registers:get_register("sp")
    local byte = self.ram[sp]
    self.registers:set_register("sp", sp + 1)

    return byte
end

function cpu.read_u16_sp_up(self)
    local right = self:read_byte_sp_up()
    local left = self:read_byte_sp_up()

    return bor(lshift(left, 8), right)
end

function cpu.write_byte_sp_down(self, val)
    local sp = self.registers:get_register("sp")
    self.ram[sp-1] = val
    self.registers:set_register("sp", sp - 1)
end

function cpu.write_u16_sp_down(self, val)
    local right = rshift(val, 8)
    local left = band(val, 0x00ff)
    self:write_byte_sp_down(right)
    self:write_byte_sp_down(left)
end

function cpu.read_u16_pc(self)
    self.registers:set_register("pc", self.registers:get_register("pc") - 2)
    local lower = self:read_byte_pc_up()
    local upper = self:read_byte_pc_up()

    return bor(lshift(upper, 8), lower)
end

local labels = require("dmg.opcodes").unprefixed

function cpu.execute(self, opcode)
    if instructions[opcode] then
        return instructions.execute(self, opcode)
    else
        print(colors('%{redbg}error: cannot find instruction '..tohex(opcode,2):upper().." at 0x"..tohex(self.registers.pc, 4)))
    end
end

function cpu.fetch(self)
    self.current.cycle = 1 -- i know they technically overlap, but gekkio docs show "Mx/M1" (x being # of cycles)
    local byte = self:read_byte_pc_up()

    return byte
end

function cpu.step(self)
    if not self.halt then
        self.current.cycle = self.current.cycle + 1

        local status = self:execute(self.current.opcode) -- returns false when instruction has not completed

        if status then
            cpu:fetch()
        end
    end
end

return cpu