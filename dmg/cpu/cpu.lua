local cpu = {}
require("bit")
local instructions = require("dmg.cpu.instructionsnew")

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
        opcode = 0, -- we can just call it again instead of reading memory
        cycle = 0, -- 0 is to fetch the next instruction, >=1 is to keep running the current instruction
        temp = 0 -- any persistent data we might need
    }
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

function cpu.fetch(self) -- redundant? whatever
    local byte = self:read_byte_pc_up()

    return byte
end

local labels = require("dmg.opcodes").unprefixed

function cpu.execute_next(self, opcode)
    if instructions[opcode] then
        return instructions.execute(self, opcode)
    else
        print(colors('%{redbg}error: cannot find instruction '..tohex(opcode,2):upper().." at 0x"..tohex(self.registers.pc, 4)))
    end
end

function cpu.step(self)
    if self.current.cycle == 0 then -- first cycle (0 in this case) is always 'fetch' for CPU
        print('fetching')
        self.current.opcode = self:fetch()
    else
        local status = self:execute_next(self.current.opcode)
        print(status)
        if status then -- when the instruction returns true, we know we are done
            self.current.cycle = 0
            print("next instruction")
            return
        end
    end

    self.current.cycle = self.current.cycle + 1 -- if instruction doesn't return true, it's not over yet!
    print("continuing")
end

return cpu