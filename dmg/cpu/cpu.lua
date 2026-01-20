local cpu = {}
require("bit")
local instructions = require("dmg.cpu.instructions")

local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

cpu.registers = {
    a = 0x00,
    b = 0x00,
    c = 0x00,
    d = 0x00,
    e = 0x00,
    f = 0x00,
    h = 0x00,
    l = 0x00,

    pc = 0x0000, --setting to -1 is just so that it starts at the first byte after it increments PC 
    sp = 0x0000,

    set_register = function(self, register, value)
        if self[register] then
            if register ~= "sp" and register ~= "pc" then
                self[register] = value % 256
                print('register '..register..' set to '..tohex(value, 2))
            else
                self[register] = value % 65536
            end
        end
    end,

    get_register = function(self, register)
        if self[register] then
            return self[register]
        end
    end,

    set_flag = function(self, flag, value) -- Z bit 7, N (subtract) bit 6, HC bit 5, C bit 4
        --print(flag.." is now "..tostring(value))
        value = value and 1 or 0
        
        local mask
        if flag == "z" then
            mask = 0x80  -- Bit 7 (Z flag)
        elseif flag == "n" then
            mask = 0x40  -- Bit 6 (N flag)
        elseif flag == "hc" then
            mask = 0x20  -- Bit 5 (HC flag)
        elseif flag == "c" then
            mask = 0x10  -- Bit 4 (C flag)
        else
            print('WARNING: invalid flag! set_flag() flag='..tostring(flag))
            return nil
        end
    
        -- To set or clear the flag, first clear the bit and then apply the value
        if value == 1 then
            -- Set the bit
            self.f = bor(self.f, mask)
        else
            -- Clear the bit
            self.f = band(self.f, bnot(mask))
        end
    end,    

    get_flag = function(self, flag)
        local result = false
        if flag == "z" then
            result = (band(self.f, 0b10000000) ~= 0)
        elseif flag == "n" then
            result = (band(self.f, 0b01000000) ~= 0)
        elseif flag == "hc" then
            result = (band(self.f, 0b00100000) ~= 0)
        elseif flag == "c" then
            result = (band(self.f, 0b00010000) ~= 0)
        else
            print('WARNING: invalid flag! get_flag() flag='..tostring(flag))
            return false
        end
        --print('get_flag '..self.f.." "..flag..tostring(result))
        return result
    end,

    set_af = function(self, value)
        value = value % 65536
        local right_byte = rshift(value,8)
        local left_byte = band(value, 0xff)

        self.a = right_byte
        self.f = left_byte
    end,

    get_af = function(self)
        return bor(lshift(self.f,8), self.a)
    end,

    set_bc = function(self, value)
        value = value % 65536
        local right_byte = rshift(value,8)
        local left_byte = band(value, 0xff)

        self.b = right_byte
        self.c = left_byte
    end,

    get_bc = function(self)
        return bor(lshift(self.b,8), self.c)
    end,

    set_de = function(self, value)
        value = value % 65536
        local right_byte = rshift(value,8)
        local left_byte = band(value, 0xff)

        self.d = right_byte
        self.e = left_byte
    end,

    get_de = function(self)
        return bor(lshift(self.d,8), self.e)
    end,

    set_hl = function(self, value)
        value = value % 65536
        local right_byte = rshift(value,8)
        local left_byte = band(value, 0xff)

        self.h = right_byte
        self.l = left_byte
    end,

    get_hl = function(self)
        return bor(lshift(self.h,8), self.l)
    end,
}

function cpu.init(system)
    io.write(colors("CPU Initializing, #instrs (non-cb): "..#instructions.."\n", "green"))
    local missing_instrs = {}
    for i = 1, 0xff do
        if not instructions[i] then
            missing_instrs[#missing_instrs+1] = bit.tohex(i, 2)
        end
    end
    print(missing_instrs)
    cpu.ram = system.ram
    cpu.cycles = 0
    cpu.message = ""
    return cpu
end

--register r/w functions

function cpu.read_byte_pc(self)
    local pc = self.registers:get_register("pc")
    local byte = self.ram[pc+1]

    return byte
end

function cpu.read_byte_pc_up(self)
    local pc = self.registers:get_register("pc")
    local byte = self.ram[pc]
    pc = pc + 1
    self.registers:set_register("pc", pc)

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

function cpu.get_next_opcode(self)
    local pc = self.registers:get_register("pc")
    local byte = self.ram[pc]
    self.registers:set_register("pc", pc+1)

    return byte
end

--(!) cpu tick function

local labels = require("dmg.opcodes").unprefixed
function cpu.execute_next(self)
    local opcode = self:get_next_opcode()
    --print("0x"..tohex(self.registers:get_register("pc")-1, 4)..": "..tohex(opcode,2))
    if instructions[opcode] then
        local opcodestr = "0x"..tohex(opcode, 2)
        print('executing: '..tohex(opcode,2):upper().." @ 0x"..tohex(self.registers.pc, 4).." | "..labels[opcodestr].mnemonic.." "..(labels[opcodestr].operand1 or "")..", "..(labels[opcodestr].operand2 or ""))
        instructions[opcode](self)
    else
        print(colors('%{redbg}error: cannot find instruction '..tohex(opcode,2):upper().." at 0x"..tohex(self.registers.pc, 4)))
    end
end

function cpu.tick(self)
    if self.cycles == 0 then
        self:execute_next()
        self.cycles = 4
    else
        self.cycles = self.cycles - 1
    end

    if self.registers.pc == 0x100 then --check if bootrom is finished
        self.ram:entry()
    end
end

return cpu