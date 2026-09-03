local instructions = {}
local opcodes = require("dmg.opcodes")

local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift,
    bit.tohex

for i = 0, 0xff do
    instructions[i] = function(cpu)
        local me = i; print("IMPLEMENT ME!!! " .. bit.tohex(i, 2) .. " @0x" .. bit.tohex(cpu.registers.pc, 4))
    end
end

function instructions.execute(cpu, opcode)
    --print("Executing 0x"..bit.tohex(opcode, 2))
    if cpu.current.cycle == 4 then
        instructions[opcode](cpu)
        return true
    end
end

--Special instructions

instructions[0x00] = function(cpu)  end --NOP
instructions[0x76] = function(cpu) cpu.update = false end          --HALT
instructions[0xf3] = function(cpu) end                             --DI TODO impl
instructions[0xd3] = function(cpu) print("---------MARKER---------") end -- special instruction

--LD: Load instructions

instructions[0x01] = function(cpu) cpu.registers:set_bc(cpu:read_u16_pc_up()) end
instructions[0x02] = function(cpu) cpu.ram[cpu.registers:get_bc()] = cpu.registers.a end
instructions[0x06] = function(cpu) cpu.registers.b = cpu:read_byte_pc_up() end
instructions[0x08] = function(cpu) cpu.ram[cpu:read_u16_pc_up()] = cpu.registers.sp end
instructions[0x0a] = function(cpu) cpu.registers.a = cpu.ram[cpu.registers:get_bc()] end
instructions[0x0e] = function(cpu) cpu.registers.c = cpu:read_byte_pc_up() end
instructions[0x11] = function(cpu) cpu.registers:set_de(cpu:read_u16_pc_up()) end
instructions[0x12] = function(cpu) cpu.ram[cpu.registers:get_de()] = cpu.registers.a end
instructions[0x16] = function(cpu) cpu.registers.d = cpu:read_byte_pc_up() end
instructions[0x1a] = function(cpu) cpu.registers.a = cpu.ram[cpu.registers:get_de()] end
instructions[0x1e] = function(cpu) cpu.registers.e = cpu:read_byte_pc_up() end
instructions[0x21] = function(cpu) cpu.registers:set_hl(cpu:read_u16_pc_up()) end
instructions[0x22] = function(cpu)
    cpu.ram[cpu.registers:get_hl()] = cpu.registers.a; cpu.registers:set_hl(cpu.registers:get_hl() + 1)
end
instructions[0x26] = function(cpu) cpu.registers.h = cpu:read_byte_pc_up() end
instructions[0x2a] = function(cpu)
    cpu.registers.a = cpu.ram[cpu.registers:get_hl()]; cpu.registers:set_hl(cpu.registers:get_hl() + 1)
end
instructions[0x2e] = function(cpu) cpu.registers.l = cpu:read_byte_pc_up() end
instructions[0x31] = function(cpu) cpu.registers.sp = cpu:read_u16_pc_up() end
instructions[0x32] = function(cpu)
    cpu.ram[cpu.registers:get_hl()] = cpu.registers.a; cpu.registers:set_hl(cpu.registers:get_hl() - 1)
end
instructions[0x36] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu:read_byte_pc_up() end
instructions[0x3a] = function(cpu)
    cpu.registers.a = cpu.ram[cpu.registers:get_hl()]; cpu.registers:set_hl(cpu.registers:get_hl() - 1)
end
instructions[0x3e] = function(cpu) cpu.registers.a = cpu:read_byte_pc_up() end
--register-to-register load instructions
instructions[0x40] = function(cpu) cpu.registers.b = cpu.registers.b end
instructions[0x41] = function(cpu) cpu.registers.b = cpu.registers.c end
instructions[0x42] = function(cpu) cpu.registers.b = cpu.registers.d end
instructions[0x43] = function(cpu) cpu.registers.b = cpu.registers.e end
instructions[0x44] = function(cpu) cpu.registers.b = cpu.registers.h end
instructions[0x45] = function(cpu) cpu.registers.b = cpu.registers.l end
instructions[0x46] = function(cpu) cpu.registers.b = cpu.ram[cpu.registers:get_hl()] end
instructions[0x47] = function(cpu) cpu.registers.b = cpu.registers.a end
instructions[0x48] = function(cpu) cpu.registers.c = cpu.registers.b end
instructions[0x49] = function(cpu) cpu.registers.c = cpu.registers.c end
instructions[0x4a] = function(cpu) cpu.registers.c = cpu.registers.d end
instructions[0x4b] = function(cpu) cpu.registers.c = cpu.registers.e end
instructions[0x4c] = function(cpu) cpu.registers.c = cpu.registers.h end
instructions[0x4d] = function(cpu) cpu.registers.c = cpu.registers.l end
instructions[0x4e] = function(cpu) cpu.registers.c = cpu.ram[cpu.registers:get_hl()] end
instructions[0x4f] = function(cpu) cpu.registers.c = cpu.registers.a end
instructions[0x50] = function(cpu) cpu.registers.d = cpu.registers.b end
instructions[0x51] = function(cpu) cpu.registers.d = cpu.registers.c end
instructions[0x52] = function(cpu) cpu.registers.d = cpu.registers.d end
instructions[0x53] = function(cpu) cpu.registers.d = cpu.registers.e end
instructions[0x54] = function(cpu) cpu.registers.d = cpu.registers.h end
instructions[0x55] = function(cpu) cpu.registers.d = cpu.registers.l end
instructions[0x56] = function(cpu) cpu.registers.d = cpu.ram[cpu.registers:get_hl()] end
instructions[0x57] = function(cpu) cpu.registers.d = cpu.registers.a end
instructions[0x58] = function(cpu) cpu.registers.e = cpu.registers.b end
instructions[0x59] = function(cpu) cpu.registers.e = cpu.registers.c end
instructions[0x5a] = function(cpu) cpu.registers.e = cpu.registers.d end
instructions[0x5b] = function(cpu) cpu.registers.e = cpu.registers.e end
instructions[0x5c] = function(cpu) cpu.registers.e = cpu.registers.h end
instructions[0x5d] = function(cpu) cpu.registers.e = cpu.registers.l end
instructions[0x5e] = function(cpu) cpu.registers.e = cpu.ram[cpu.registers:get_hl()] end
instructions[0x5f] = function(cpu) cpu.registers.e = cpu.registers.a end
instructions[0x60] = function(cpu) cpu.registers.h = cpu.registers.b end
instructions[0x61] = function(cpu) cpu.registers.h = cpu.registers.c end
instructions[0x62] = function(cpu) cpu.registers.h = cpu.registers.d end
instructions[0x63] = function(cpu) cpu.registers.h = cpu.registers.e end
instructions[0x64] = function(cpu) cpu.registers.h = cpu.registers.h end
instructions[0x65] = function(cpu) cpu.registers.h = cpu.registers.l end
instructions[0x66] = function(cpu) cpu.registers.h = cpu.ram[cpu.registers:get_hl()] end
instructions[0x67] = function(cpu) cpu.registers.h = cpu.registers.a end
instructions[0x68] = function(cpu) cpu.registers.l = cpu.registers.b end
instructions[0x69] = function(cpu) cpu.registers.l = cpu.registers.c end
instructions[0x6a] = function(cpu) cpu.registers.l = cpu.registers.d end
instructions[0x6b] = function(cpu) cpu.registers.l = cpu.registers.e end
instructions[0x6c] = function(cpu) cpu.registers.l = cpu.registers.h end
instructions[0x6d] = function(cpu) cpu.registers.l = cpu.registers.l end
instructions[0x6e] = function(cpu) cpu.registers.l = cpu.ram[cpu.registers:get_hl()] end
instructions[0x6f] = function(cpu) cpu.registers.l = cpu.registers.a end
instructions[0x70] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.b end
instructions[0x71] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.c end
instructions[0x72] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.d end
instructions[0x73] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.e end
instructions[0x74] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.h end
instructions[0x75] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.l end
instructions[0x77] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.a end
instructions[0x78] = function(cpu) cpu.registers.a = cpu.registers.b end
instructions[0x79] = function(cpu) cpu.registers.a = cpu.registers.c end
instructions[0x7a] = function(cpu) cpu.registers.a = cpu.registers.d end
instructions[0x7b] = function(cpu) cpu.registers.a = cpu.registers.e end
instructions[0x7c] = function(cpu) cpu.registers.a = cpu.registers.h end
instructions[0x7d] = function(cpu) cpu.registers.a = cpu.registers.l end
instructions[0x7e] = function(cpu) cpu.registers.a = cpu.ram[cpu.registers:get_hl()] end
instructions[0x7f] = function(cpu) cpu.registers.a = cpu.registers.a end

instructions[0xe2] = function(cpu) cpu.ram[0xff00 + cpu.registers.c] = cpu.registers.a end
instructions[0xea] = function(cpu) cpu.ram[cpu:read_u16_pc_up()] = cpu.registers.a end
instructions[0xf2] = function(cpu) cpu.registers.a = cpu.ram[0xff00 + cpu.registers.c] end
instructions[0xf8] = function(cpu) cpu.registers:set_hl(cpu.registers.sp + cpu:read_byte_pc_up()) end
instructions[0xf9] = function(cpu) cpu.registers.sp = cpu.registers:get_hl() end
instructions[0xfa] = function(cpu) cpu.registers.a = cpu.ram[cpu:read_u16_pc_up()] end

--LDH: Load instructions +0xFF00

instructions[0xe0] = function(cpu) cpu.ram[0xFF00 + cpu:read_byte_pc_up()] = cpu.registers.a end
instructions[0xf0] = function(cpu) cpu.registers.a = cpu.ram[0xFF00 + cpu:read_byte_pc_up()] end

--Arithmetic instructions

--ADD

local function setIncFlags(cpu, value)
    cpu.registers:set_flag("z", value == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", band(value-1, 0x0F) == 0x0F)
end

local function setDecFlags(cpu, value)
    cpu.registers:set_flag("z", value == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", band(value+1, 0x0F) == 0x00)
end

local function addA(cpu, v, modifyflags)
    modifyflags = modifyflags or true
    local a = cpu.registers.a
    local result = (a + v)
    local wrapped = band(result, 0b11111111)

    cpu.registers.a = wrapped

    if modifyflags then
        cpu.registers:set_flag("z", wrapped == 0)
        cpu.registers:set_flag("n", false)
        cpu.registers:set_flag("hc", (band(a, 0xF) + band(v, 0xF)) > 0xF)
    end
end

instructions[0x09] = function(cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers:get_bc()) end
instructions[0x19] = function(cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers:get_de()) end
instructions[0x29] = function(cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers:get_hl()) end
instructions[0x39] = function(cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers.sp) end
instructions[0x80] = function(cpu) addA(cpu, cpu.registers.b) end
instructions[0x81] = function(cpu) addA(cpu, cpu.registers.c) end
instructions[0x82] = function(cpu) addA(cpu, cpu.registers.d) end
instructions[0x83] = function(cpu) addA(cpu, cpu.registers.e) end
instructions[0x84] = function(cpu) addA(cpu, cpu.registers.h) end
instructions[0x85] = function(cpu) addA(cpu, cpu.registers.l) end
instructions[0x86] = function(cpu) addA(cpu, cpu.ram[cpu.registers:get_hl()], false) end
instructions[0x87] = function(cpu) addA(cpu, cpu.registers.a) end
instructions[0xc6] = function(cpu) cpu.registers.a = cpu.registers.a + cpu:read_byte_pc_up() end
instructions[0xe8] = function(cpu) cpu.registers.sp = cpu.registers.sp + cpu:read_byte_pc_up() end

--ADC

instructions[0x88] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.registers.b +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x89] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.registers.c +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x8a] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.registers.d +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x8b] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.registers.e +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x8c] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.registers.h +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x8d] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.registers.l +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x8e] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.ram[cpu.registers:get_hl()] +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x8f] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu.registers.a +
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0xce] = function(cpu)
    cpu.registers.a = cpu.registers.a + cpu:read_byte_pc_up() +
        (cpu.registers:get_flag("c") and 1 or 0)
end

--SUB

local function subA(cpu, v, modifyflags)
    modifyflags = modifyflags or true
    local a = cpu.registers.a
    local result = cpu.registers.a - v
    local wrapped = band(result, 0b11111111)

    cpu.registers.a = wrapped

    if modifyflags then
        cpu.registers:set_flag("z", wrapped == 0)
        cpu.registers:set_flag("n", true)
        cpu.registers:set_flag("hc", (band(a, 0xF) + band(v, 0xF)) > 0xF)
        cpu.registers:set_flag("c", band(result, 0x100) > 0)
    end
end

instructions[0x90] = function(cpu) subA(cpu, cpu.registers.b) end
instructions[0x91] = function(cpu) subA(cpu, cpu.registers.c) end
instructions[0x92] = function(cpu) subA(cpu, cpu.registers.d) end
instructions[0x93] = function(cpu) subA(cpu, cpu.registers.e) end
instructions[0x94] = function(cpu) subA(cpu, cpu.registers.h) end
instructions[0x95] = function(cpu) subA(cpu, cpu.registers.l) end
instructions[0x96] = function(cpu) subA(cpu, cpu.ram[cpu.registers:get_hl()]) end
instructions[0x97] = function(cpu) subA(cpu, cpu.registers.a) end
instructions[0xd6] = function(cpu) subA(cpu, cpu:read_byte_pc_up()) end

--SBC

instructions[0x98] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.registers.b -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x99] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.registers.c -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x9a] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.registers.d -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x9b] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.registers.e -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x9c] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.registers.h -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x9d] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.registers.l -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x9e] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.ram[cpu.registers:get_hl()] -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0x9f] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu.registers.a -
        (cpu.registers:get_flag("c") and 1 or 0)
end
instructions[0xde] = function(cpu)
    cpu.registers.a = cpu.registers.a - cpu:read_byte_pc_up() -
        (cpu.registers:get_flag("c") and 1 or 0)
end

--INC

instructions[0x03] = function(cpu) cpu.registers:set_bc(cpu.registers:get_bc() + 1) end
instructions[0x04] = function(cpu)
    cpu.registers.b = (cpu.registers.b + 1) % 256; setIncFlags(cpu, cpu.registers.b)
end
instructions[0x0c] = function(cpu)
    cpu.registers.c = (cpu.registers.c + 1) % 256; setIncFlags(cpu, cpu.registers.c)
end

instructions[0x13] = function(cpu) cpu.registers:set_de(cpu.registers:get_de() + 1) end
instructions[0x14] = function(cpu)
    cpu.registers.d = (cpu.registers.d + 1) % 256; setIncFlags(cpu, cpu.registers.d)
end
instructions[0x1c] = function(cpu)
    cpu.registers.e = (cpu.registers.e + 1) % 256; setIncFlags(cpu, cpu.registers.e)
end

instructions[0x23] = function(cpu) cpu.registers:set_hl(cpu.registers:get_hl() + 1) end
instructions[0x24] = function(cpu)
    cpu.registers.h = (cpu.registers.h + 1) % 256; setIncFlags(cpu, cpu.registers.h)
end
instructions[0x2c] = function(cpu)
    cpu.registers.l = (cpu.registers.l + 1) % 256; setIncFlags(cpu, cpu.registers.l)
end

instructions[0x33] = function(cpu) cpu.registers.sp = cpu.registers.sp + 1 end
instructions[0x34] = function(cpu) cpu.ram[cpu.registers:get_hl()] = cpu.ram[cpu.registers:get_hl()] + 1 end
instructions[0x3c] = function(cpu)
    cpu.registers.a = (cpu.registers.a + 1) % 256; setIncFlags(cpu, cpu.registers.a)
end

--DEC

instructions[0x05] = function(cpu)
    cpu.registers.b = (cpu.registers.b - 1) % 256; setDecFlags(cpu, cpu.registers.b)
end
instructions[0x0b] = function(cpu) cpu.registers:set_bc(cpu.registers:get_bc() - 1) end
instructions[0x0d] = function(cpu)
    cpu.registers.c = (cpu.registers.c - 1) % 256; setDecFlags(cpu, cpu.registers.c)
end

instructions[0x15] = function(cpu)
    cpu.registers.d = (cpu.registers.d - 1) % 256; setDecFlags(cpu, cpu.registers.d)
end
instructions[0x1b] = function(cpu)
    cpu.registers:set_de(cpu.registers:get_de() - 1); setDecFlags(cpu, cpu.registers:get_de())
end
instructions[0x1d] = function(cpu)
    cpu.registers.e = (cpu.registers.e - 1) % 256; setDecFlags(cpu, cpu.registers.e)
end

instructions[0x25] = function(cpu)
    cpu.registers.h = (cpu.registers.h - 1) % 256; setDecFlags(cpu, cpu.registers.h)
end
instructions[0x2b] = function(cpu)
    cpu.registers:set_hl(cpu.registers:get_hl() - 1); setDecFlags(cpu, cpu.registers:get_hl())
end
instructions[0x2d] = function(cpu)
    cpu.registers.l = (cpu.registers.l - 1) % 256; setDecFlags(cpu, cpu.registers.l)
end

instructions[0x35] = function(cpu)
    cpu.ram[cpu.registers:get_hl()] = cpu.ram[cpu.registers:get_hl()] - 1; setDecFlags(cpu,
        cpu.ram[cpu.registers:get_hl()])
end
instructions[0x3b] = function(cpu)
    cpu.registers.sp = cpu.registers.sp - 1; setDecFlags(cpu, cpu.registers.sp)
end
instructions[0x3d] = function(cpu)
    cpu.registers.a = (cpu.registers.a - 1) % 256; setDecFlags(cpu, cpu.registers.a)
end

--Logical instructions

local function andFlags(cpu, val1, val2)
    local result = band(val1, val2)
    cpu.registers:set_flag("z", result == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", true)
    cpu.registers:set_flag("c", false)
    return result
end

local function xorFlags(cpu, val1, val2)
    local result = bxor(val1, val2)
    cpu.registers:set_flag("z", result == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)
    cpu.registers:set_flag("c", false)
    return result
end

local function orFlags(cpu, val1, val2)
    local result = bor(val1, val2)
    cpu.registers:set_flag("z", result == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)
    cpu.registers:set_flag("c", false)
    return result
end

local function cpFlags(cpu, val1, val2) --val1 should always be reg a
    local result = val1 - val2
    cpu.registers:set_flag("z", result == 0)
    cpu.registers:set_flag("n", true)
    cpu.registers:set_flag("hc", bit.band(val1, 0b00001111) < bit.band(val2, 0b00001111))
    cpu.registers:set_flag("c", val1 < val2) --if borrow occurs
    return result
end

--AND

instructions[0xa0] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xa1] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xa2] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xa3] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xa4] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xa5] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xa6] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xa7] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.a) end

instructions[0xE6] = function(cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu:read_byte_pc_up()) end --d8

--XOR

instructions[0xee] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu:read_byte_pc_up()) end
instructions[0xa8] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xa9] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xaa] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xab] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xac] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xad] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xae] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xaf] = function(cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.a) end

--OR

instructions[0xb0] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xb1] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xb2] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xb3] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xb4] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xb5] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xb6] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xb7] = function(cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.a) end

--CP

instructions[0xb8] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xb9] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xba] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xbb] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xbc] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xbd] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xbe] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xbf] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.a) end
instructions[0xfe] = function(cpu) cpFlags(cpu, cpu.registers.a, cpu:read_byte_pc_up()) end

--Misc Arithmetic Instructions

--DAA (TODO)

instructions[0x37] = function(cpu) --SCF (set carry)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)
    cpu.registers:set_flag("c", true)
end

instructions[0x2f] = function(cpu) --CPL (flip a)
    cpu.registers.a = bnot(cpu.registers.a)
    cpu.registers:set_flag("n", true)
    cpu.registers:set_flag("hc", true)
end

instructions[0x3f] = function(cpu) --CCF (flip carry)
    cpu.registers:set_flag("c", not cpu.registers:get_flag("c"))
end

--Jump/call instructions

--JP

instructions[0xc2] = function(cpu) if not cpu.registers:get_flag("z") then cpu.registers.pc = cpu:read_u16_pc_up() end end --NZ
instructions[0xc3] = function(cpu) cpu.registers.pc = cpu:read_u16_pc_up() end
instructions[0xca] = function(cpu) if cpu.registers:get_flag("z") then cpu.registers.pc = cpu:read_u16_pc_up() end end     --Z
instructions[0xd2] = function(cpu) if not cpu.registers:get_flag("c") then cpu.registers.pc = cpu:read_u16_pc_up() end end --NC
instructions[0xda] = function(cpu) if cpu.registers:get_flag("c") then cpu.registers.pc = cpu:read_u16_pc_up() end end     --C
instructions[0xe9] = function(cpu) cpu.registers.pc = cpu.registers:get_hl() end

--JR

local function signed_byte(val)
    if val > 127 then
        val = val - 256
    end
    return val + 1
end

instructions[0x18] = function(cpu) cpu.registers.pc = cpu.registers.pc + signed_byte(cpu:read_byte_pc_up()) end
instructions[0x20] = function(cpu)
    if not cpu.registers:get_flag("z") then
        cpu.registers.pc = cpu.registers.pc +
            signed_byte(cpu:read_byte_pc_up())
    else
        cpu:read_byte_pc_up()
        print("z")
    end
end                                                                           --NZ
instructions[0x28] = function(cpu)
    if cpu.registers:get_flag("z") then
        cpu.registers.pc = cpu.registers.pc +
            signed_byte(cpu:read_byte_pc_up())
    else
        cpu:read_byte_pc_up()
    end
end                                                                           --Z
instructions[0x30] = function(cpu)
    if not cpu.registers:get_flag("c") then
        cpu.registers.pc = cpu.registers.pc +
            signed_byte(cpu:read_byte_pc_up())
    else
        cpu:read_byte_pc_up()
    end
end                                                                           --NC
instructions[0x38] = function(cpu)
    if cpu.registers:get_flag("c") then
        cpu.registers.pc = cpu.registers.pc +
            signed_byte(cpu:read_byte_pc_up())
    else
        cpu:read_byte_pc_up()
    end
end                                                                           --C

--CALL

instructions[0xc4] = function(cpu)
    if not cpu.registers:get_flag("z") then
        cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up()
    end
end
instructions[0xcc] = function(cpu)
    if cpu.registers:get_flag("z") then
        cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up()
    end
end
instructions[0xcd] = function(cpu)
    cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up()
end
instructions[0xd4] = function(cpu)
    if not cpu.registers:get_flag("c") then
        cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up()
    end
end
instructions[0xdc] = function(cpu)
    if cpu.registers:get_flag("c") then
        cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up()
    end
end

--RET
instructions[0xc0] = function(cpu) if not cpu.registers:get_flag("z") then cpu.registers.pc = cpu:read_u16_sp_up() end end --NZ
instructions[0xc8] = function(cpu) if cpu.registers:get_flag("z") then cpu.registers.pc = cpu:read_u16_sp_up() end end --Z
instructions[0xc9] = function(cpu) cpu.registers.pc = cpu:read_u16_sp_up() end
instructions[0xd0] = function(cpu) if not cpu.registers:get_flag("c") then cpu.registers.pc = cpu:read_u16_sp_up() end end -- NC

--RST

function RST(cpu, offset)
    cpu:write_u16_sp_down(cpu.registers.pc)
    cpu.registers.pc = offset
end

instructions[0xef] = function(cpu) RST(cpu, 0x0028) end

--Stack instructions (POP/PUSH)
--POP

instructions[0xc1] = function(cpu) cpu.registers:set_bc(cpu:read_u16_sp_up()) end
instructions[0xd1] = function(cpu) cpu.registers:set_de(cpu:read_u16_sp_up()) end
instructions[0xe1] = function(cpu) cpu.registers:set_hl(cpu:read_u16_sp_up()) end
instructions[0xf1] = function(cpu) cpu.registers:set_af(cpu:read_u16_sp_up()) end

--PUSH

instructions[0xc5] = function(cpu) cpu:write_u16_sp_down(cpu.registers:get_bc()) end
instructions[0xd5] = function(cpu) cpu:write_u16_sp_down(cpu.registers:get_de()) end
instructions[0xe5] = function(cpu) cpu:write_u16_sp_down(cpu.registers:get_hl()) end
instructions[0xf5] = function(cpu) cpu:write_u16_sp_down(cpu.registers:get_af()) end

--Bitwise instructions

local function RLCA(cpu)
    local a = cpu.registers.a
    local bit7 = rshift(a, 7)
    a = lshift(a, 1)
    a = band(a, 0b11111111) + bit7
    cpu.registers.a = a

    cpu.registers:set_flag("z", false)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)
    cpu.registers:set_flag("c", bit7 == 1)
end

instructions[0x07] = function(cpu) RLCA(cpu) end

local function DAA(cpu)
    --[[
        Decimal Adjust Accumulator
        Adjust hex values so they are a base-10 decimal representation from 0-99 (as 0x00-0x99)
        Result is a binary-coded decimal (BCD)
    ]]
    local value = cpu.registers.a
    
    local lower = bor((band(value, 0xF) > 9) and 1 or 0, cpu.registers:get_flag("hc") and 1 or 0) -- check if the lower nibble is greather than 9 or if half carry is true, then convert that to a number
    local upper = bor((rshift(value, 1) > 9) and 1 or 0, cpu.registers.get_flag("c") and 1 or 0) -- same with upper nibble and the carry flag

    local sign = -(cpu.registers:get_flag("n") and 1 or 0)
    local adjust = (upper * 0x60) + (lower * 0x06) -- this is what we add to the value to make it a BCD, 6 is derived from the difference from base 10 to 16

    value = band(value + bxor(adjust, sign) - sign, 0xFF)

    -- local z = (a == 0) and 1 or 0
    -- h = 0
    -- c = hi_invalid

    cpu.registers:set_flag("z", (value == 0))
    cpu.registers:set_flag("h", false)
    cpu.registers:set_flag("hc", upper)
end

--instructions[0x27] = function(cpu) DAA(cpu) end

--[[
    Begin Prefix CB instructions
    Byte ahead of opcode CB is prefixed instruction
    for example 0xCB 0x7C is BIT 7,H
]]

local prefixed = {}

for i = 0, 0xff do
    prefixed[i] = function(cpu)
        local me = i; print("IMPLEMENT ME!!! CB+" .. bit.tohex(i, 2))
    end
end

local function rlc(cpu, value)
    local bit7 = bit.rshift(value, 7)
    cpu.registers:set_flag("c", bit7 == 1)

    value = bit.lshift(value, 1)
    value = bit.bor(value, bit7)        -- union old bit 7 to copy it to new bit 0
    value = bit.band(value, 0b11111111) -- keep it within 8 bits

    cpu.registers:set_flag("z", value == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)

    return value
end

local function rrc(cpu, value)
    local bit0 = bit.band(value, 0b00000001)
    cpu.registers:set_flag("c", bit0 == 1)

    value = bit.rshift(value, 1)
    value = bit.bor(value, lshift(bit0, 7)) -- union old bit 0 to copy it to new bit 7
    value = bit.band(value, 0b11111111)     -- keep it within 8 bits

    cpu.registers:set_flag("z", value == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)

    return value
end

--RLC

prefixed[0x00] = function(cpu) cpu.registers.b = rlc(cpu, cpu.registers.b) end
prefixed[0x01] = function(cpu) cpu.registers.c = rlc(cpu, cpu.registers.c) end
prefixed[0x02] = function(cpu) cpu.registers.d = rlc(cpu, cpu.registers.d) end
prefixed[0x03] = function(cpu) cpu.registers.e = rlc(cpu, cpu.registers.e) end
prefixed[0x04] = function(cpu) cpu.registers.h = rlc(cpu, cpu.registers.h) end
prefixed[0x05] = function(cpu) cpu.registers.l = rlc(cpu, cpu.registers.l) end
prefixed[0x06] = function(cpu) cpu.ram[cpu.registers:get_hl()] = rlc(cpu, cpu.registers:get_hl()) end
prefixed[0x07] = function(cpu) cpu.registers.a = rlc(cpu, cpu.registers.a) end

--RRC

prefixed[0x08] = function(cpu) cpu.registers.b = rrc(cpu, cpu.registers.b) end
prefixed[0x09] = function(cpu) cpu.registers.c = rrc(cpu, cpu.registers.c) end
prefixed[0x0a] = function(cpu) cpu.registers.d = rrc(cpu, cpu.registers.d) end
prefixed[0x0b] = function(cpu) cpu.registers.e = rrc(cpu, cpu.registers.e) end
prefixed[0x0c] = function(cpu) cpu.registers.h = rrc(cpu, cpu.registers.h) end
prefixed[0x0d] = function(cpu) cpu.registers.l = rrc(cpu, cpu.registers.l) end
prefixed[0x0e] = function(cpu) cpu.ram[cpu.registers:get_hl()] = rrc(cpu, cpu.registers:get_hl()) end
prefixed[0x0f] = function(cpu) cpu.registers.a = rrc(cpu, cpu.registers.a) end

--RL

local function rl_c(cpu, value)                                  -- rotate left through carry
    local carry = rshift(value, 7)                               -- Extract carry as 1 or 0
    value = band(lshift(value, 1), 0b11111111)                   -- Rotate left and mask to 8 bits
    value = bor(value, (cpu.registers:get_flag("c") and 1 or 0)) -- Add old carry to LSB
    cpu.registers:set_flag("c", carry ~= 0)                      -- Set carry flag
    return value
end

instructions[0x17] = function(cpu) cpu.registers.a = rl_c(cpu, cpu.registers.a) end --RLA

prefixed[0x10] = function(cpu) cpu.registers.b = rl_c(cpu, cpu.registers.b) end
prefixed[0x11] = function(cpu) cpu.registers.c = rl_c(cpu, cpu.registers.c) end
prefixed[0x12] = function(cpu) cpu.registers.d = rl_c(cpu, cpu.registers.d) end
prefixed[0x13] = function(cpu) cpu.registers.e = rl_c(cpu, cpu.registers.e) end
prefixed[0x14] = function(cpu) cpu.registers.h = rl_c(cpu, cpu.registers.h) end
prefixed[0x15] = function(cpu) cpu.registers.l = rl_c(cpu, cpu.registers.l) end
prefixed[0x16] = function(cpu) cpu.ram[cpu.registers:get_hl()] = rl_c(cpu, cpu.registers:get_hl()) end
prefixed[0x17] = function(cpu) cpu.registers.a = rl_c(cpu, cpu.registers.a) end

--RR

local function rr_c(cpu, value)                                  -- rotate left through carry
    local carry = band(value, 1)                                 -- Extract carry as 1 or 0
    value = rshift(value, 1)                 -- Rotate left and mask to 8 bits
    value = bor(value, (cpu.registers:get_flag("c") and 1 or 0)) -- Add old carry to LSB
    cpu.registers:set_flag("c", carry ~= 0)                      -- Set carry flag
    return value
end

instructions[0x1f] = function(cpu) cpu.registers.a = rr_c(cpu, cpu.registers.a) end --RRA

prefixed[0x18] = function(cpu) cpu.registers.b = rr_c(cpu, cpu.registers.b) end
prefixed[0x19] = function(cpu) cpu.registers.c = rr_c(cpu, cpu.registers.c) end
prefixed[0x1a] = function(cpu) cpu.registers.d = rr_c(cpu, cpu.registers.d) end
prefixed[0x1b] = function(cpu) cpu.registers.e = rr_c(cpu, cpu.registers.e) end
prefixed[0x1c] = function(cpu) cpu.registers.h = rr_c(cpu, cpu.registers.h) end
prefixed[0x1d] = function(cpu) cpu.registers.l = rr_c(cpu, cpu.registers.l) end
prefixed[0x1e] = function(cpu) cpu.ram[cpu.registers:get_hl()] = rr_c(cpu, cpu.registers:get_hl()) end
prefixed[0x1f] = function(cpu) cpu.registers.a = rr_c(cpu, cpu.registers.a) end

local function swap(val)
    local upper = rshift(band(val, 0b11110000), 4)
    local lower = band(0b00001111, val)
    val = bor(lshift(lower, 4), upper)
    return val
end

prefixed[0x37] = function(cpu) cpu.registers.a = swap(cpu.registers.a) end

function SRL(cpu, val)
    local shifted = rshift(val, 1)

    cpu.registers:set_flag("z", shifted == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)
    cpu.registers:set_flag("c", band(val, 0b00000001) == 1)
    return shifted
end

prefixed[0x38] = function(cpu) cpu.registers.b = SRL(cpu, cpu.registers.b) end
prefixed[0x39] = function(cpu) cpu.registers.c = SRL(cpu, cpu.registers.c) end
prefixed[0x3a] = function(cpu) cpu.registers.d = SRL(cpu, cpu.registers.d) end
prefixed[0x3b] = function(cpu) cpu.registers.e = SRL(cpu, cpu.registers.e) end
prefixed[0x3c] = function(cpu) cpu.registers.h = SRL(cpu, cpu.registers.h) end
prefixed[0x3d] = function(cpu) cpu.registers.l = SRL(cpu, cpu.registers.l) end
prefixed[0x3e] = function(cpu) cpu.registers:set_hl(SRL(cpu, cpu.registers:get_hl())) end
prefixed[0x3f] = function(cpu) cpu.registers.a = SRL(cpu, cpu.registers.a) end

--all of the fun bit stuff (huge chunk of CB opcodes)

function BIT(cpu, val, bit)
    local check = band(val, lshift(1, bit)) == 0

    cpu.registers:set_flag("z", check)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", true)
end

--BIT 0

prefixed[0x40] = function(cpu) BIT(cpu, cpu.registers.b, 0) end
prefixed[0x41] = function(cpu) BIT(cpu, cpu.registers.c, 0) end
prefixed[0x42] = function(cpu) BIT(cpu, cpu.registers.d, 0) end
prefixed[0x43] = function(cpu) BIT(cpu, cpu.registers.e, 0) end
prefixed[0x44] = function(cpu) BIT(cpu, cpu.registers.h, 0) end
prefixed[0x45] = function(cpu) BIT(cpu, cpu.registers.l, 0) end
prefixed[0x46] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 0) end
prefixed[0x47] = function(cpu) BIT(cpu, cpu.registers.b, 0) end

--BIT 1

prefixed[0x48] = function(cpu) BIT(cpu, cpu.registers.b, 1) end
prefixed[0x49] = function(cpu) BIT(cpu, cpu.registers.c, 1) end
prefixed[0x4a] = function(cpu) BIT(cpu, cpu.registers.d, 1) end
prefixed[0x4b] = function(cpu) BIT(cpu, cpu.registers.e, 1) end
prefixed[0x4c] = function(cpu) BIT(cpu, cpu.registers.h, 1) end
prefixed[0x4d] = function(cpu) BIT(cpu, cpu.registers.l, 1) end
prefixed[0x4e] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 1) end
prefixed[0x4f] = function(cpu) BIT(cpu, cpu.registers.b, 1) end

--BIT 2

prefixed[0x50] = function(cpu) BIT(cpu, cpu.registers.b, 2) end
prefixed[0x51] = function(cpu) BIT(cpu, cpu.registers.c, 2) end
prefixed[0x52] = function(cpu) BIT(cpu, cpu.registers.d, 2) end
prefixed[0x53] = function(cpu) BIT(cpu, cpu.registers.e, 2) end
prefixed[0x54] = function(cpu) BIT(cpu, cpu.registers.h, 2) end
prefixed[0x55] = function(cpu) BIT(cpu, cpu.registers.l, 2) end
prefixed[0x56] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 2) end
prefixed[0x57] = function(cpu) BIT(cpu, cpu.registers.b, 2) end

--BIT 3

prefixed[0x58] = function(cpu) BIT(cpu, cpu.registers.b, 3) end
prefixed[0x59] = function(cpu) BIT(cpu, cpu.registers.c, 3) end
prefixed[0x5a] = function(cpu) BIT(cpu, cpu.registers.d, 3) end
prefixed[0x5b] = function(cpu) BIT(cpu, cpu.registers.e, 3) end
prefixed[0x5c] = function(cpu) BIT(cpu, cpu.registers.h, 3) end
prefixed[0x5d] = function(cpu) BIT(cpu, cpu.registers.l, 3) end
prefixed[0x5e] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 3) end
prefixed[0x5f] = function(cpu) BIT(cpu, cpu.registers.b, 3) end

--BIT 4

prefixed[0x60] = function(cpu) BIT(cpu, cpu.registers.b, 4) end
prefixed[0x61] = function(cpu) BIT(cpu, cpu.registers.c, 4) end
prefixed[0x62] = function(cpu) BIT(cpu, cpu.registers.d, 4) end
prefixed[0x63] = function(cpu) BIT(cpu, cpu.registers.e, 4) end
prefixed[0x64] = function(cpu) BIT(cpu, cpu.registers.h, 4) end
prefixed[0x65] = function(cpu) BIT(cpu, cpu.registers.l, 4) end
prefixed[0x66] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 4) end
prefixed[0x67] = function(cpu) BIT(cpu, cpu.registers.b, 4) end

--BIT 5

prefixed[0x68] = function(cpu) BIT(cpu, cpu.registers.b, 5) end
prefixed[0x69] = function(cpu) BIT(cpu, cpu.registers.c, 5) end
prefixed[0x6a] = function(cpu) BIT(cpu, cpu.registers.d, 5) end
prefixed[0x6b] = function(cpu) BIT(cpu, cpu.registers.e, 5) end
prefixed[0x6c] = function(cpu) BIT(cpu, cpu.registers.h, 5) end
prefixed[0x6d] = function(cpu) BIT(cpu, cpu.registers.l, 5) end
prefixed[0x6e] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 5) end
prefixed[0x6f] = function(cpu) BIT(cpu, cpu.registers.b, 5) end

--BIT 6

prefixed[0x70] = function(cpu) BIT(cpu, cpu.registers.b, 6) end
prefixed[0x71] = function(cpu) BIT(cpu, cpu.registers.c, 6) end
prefixed[0x72] = function(cpu) BIT(cpu, cpu.registers.d, 6) end
prefixed[0x73] = function(cpu) BIT(cpu, cpu.registers.e, 6) end
prefixed[0x74] = function(cpu) BIT(cpu, cpu.registers.h, 6) end
prefixed[0x75] = function(cpu) BIT(cpu, cpu.registers.l, 6) end
prefixed[0x76] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 6) end
prefixed[0x77] = function(cpu) BIT(cpu, cpu.registers.b, 6) end

--BIT 7

prefixed[0x78] = function(cpu) BIT(cpu, cpu.registers.b, 7) end
prefixed[0x79] = function(cpu) BIT(cpu, cpu.registers.c, 7) end
prefixed[0x7a] = function(cpu) BIT(cpu, cpu.registers.d, 7) end
prefixed[0x7b] = function(cpu) BIT(cpu, cpu.registers.e, 7) end
prefixed[0x7c] = function(cpu) BIT(cpu, cpu.registers.h, 7) end
prefixed[0x7d] = function(cpu) BIT(cpu, cpu.registers.l, 7) end
prefixed[0x7e] = function(cpu) BIT(cpu, cpu.ram[cpu.registers:get_hl()], 7) end
prefixed[0x7f] = function(cpu) BIT(cpu, cpu.registers.b, 7) end

--RES instructions

function RES(cpu, val, bit)
    return bnot(val, lshift(1, bit))
end

--RES 0

prefixed[0x80] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 0) end
prefixed[0x81] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 0) end
prefixed[0x82] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 0) end
prefixed[0x83] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 0) end
prefixed[0x84] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 0) end
prefixed[0x85] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 0) end
prefixed[0x86] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 0)) end
prefixed[0x87] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 0) end

--RES 1

prefixed[0x88] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 1) end
prefixed[0x89] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 1) end
prefixed[0x8A] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 1) end
prefixed[0x8B] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 1) end
prefixed[0x8C] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 1) end
prefixed[0x8D] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 1) end
prefixed[0x8E] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 1)) end
prefixed[0x8F] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 1) end

--RES 2

prefixed[0x90] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 2) end
prefixed[0x91] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 2) end
prefixed[0x92] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 2) end
prefixed[0x93] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 2) end
prefixed[0x94] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 2) end
prefixed[0x95] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 2) end
prefixed[0x96] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 2)) end
prefixed[0x97] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 2) end

--RES 3

prefixed[0x98] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 3) end
prefixed[0x99] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 3) end
prefixed[0x9A] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 3) end
prefixed[0x9B] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 3) end
prefixed[0x9C] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 3) end
prefixed[0x9D] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 3) end
prefixed[0x9E] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 3)) end
prefixed[0x9F] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 3) end

--RES 4

prefixed[0xA0] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 4) end
prefixed[0xA1] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 4) end
prefixed[0xA2] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 4) end
prefixed[0xA3] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 4) end
prefixed[0xA4] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 4) end
prefixed[0xA5] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 4) end
prefixed[0xA6] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 4)) end
prefixed[0xA7] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 4) end

--RES 5

prefixed[0xA8] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 5) end
prefixed[0xA9] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 5) end
prefixed[0xAA] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 5) end
prefixed[0xAB] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 5) end
prefixed[0xAC] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 5) end
prefixed[0xAD] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 5) end
prefixed[0xAE] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 5)) end
prefixed[0xAF] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 5) end

--RES 6

prefixed[0xB0] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 6) end
prefixed[0xB1] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 6) end
prefixed[0xB2] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 6) end
prefixed[0xB3] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 6) end
prefixed[0xB4] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 6) end
prefixed[0xB5] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 6) end
prefixed[0xB6] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 6)) end
prefixed[0xB7] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 6) end

--RES 7

prefixed[0xB8] = function (cpu) cpu.registers.b = RES(cpu, cpu.registers.b, 7) end
prefixed[0xB9] = function (cpu) cpu.registers.c = RES(cpu, cpu.registers.c, 7) end
prefixed[0xBA] = function (cpu) cpu.registers.d = RES(cpu, cpu.registers.d, 7) end
prefixed[0xBB] = function (cpu) cpu.registers.e = RES(cpu, cpu.registers.e, 7) end
prefixed[0xBC] = function (cpu) cpu.registers.h = RES(cpu, cpu.registers.h, 7) end
prefixed[0xBD] = function (cpu) cpu.registers.l = RES(cpu, cpu.registers.l, 7) end
prefixed[0xBE] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (RES(cpu, cpu.ram[cpu.registers:get_hl()], 7)) end
prefixed[0xBF] = function (cpu) cpu.registers.a = RES(cpu, cpu.registers.a, 7) end

--SET instructions

function SET(cpu, val, bit)
    return bor(val, lshift(1, bit))
end

--SET 0

prefixed[0xC0] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 0) end
prefixed[0xC1] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 0) end
prefixed[0xC2] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 0) end
prefixed[0xC3] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 0) end
prefixed[0xC4] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 0) end
prefixed[0xC5] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 0) end
prefixed[0xC6] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 0)) end
prefixed[0xC7] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 0) end

--SET 1

prefixed[0xC8] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 1) end
prefixed[0xC9] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 1) end
prefixed[0xCA] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 1) end
prefixed[0xCB] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 1) end
prefixed[0xCC] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 1) end
prefixed[0xCD] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 1) end
prefixed[0xCE] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 1)) end
prefixed[0xCF] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 1) end

--SET 2

prefixed[0xD0] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 2) end
prefixed[0xD1] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 2) end
prefixed[0xD2] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 2) end
prefixed[0xD3] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 2) end
prefixed[0xD4] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 2) end
prefixed[0xD5] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 2) end
prefixed[0xD6] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 2)) end
prefixed[0xD7] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 2) end

--SET 3

prefixed[0xD8] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 3) end
prefixed[0xD9] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 3) end
prefixed[0xDA] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 3) end
prefixed[0xDB] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 3) end
prefixed[0xDC] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 3) end
prefixed[0xDD] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 3) end
prefixed[0xDE] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 3)) end
prefixed[0xDF] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 3) end

--SET 4

prefixed[0xE0] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 4) end
prefixed[0xE1] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 4) end
prefixed[0xE2] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 4) end
prefixed[0xE3] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 4) end
prefixed[0xE4] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 4) end
prefixed[0xE5] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 4) end
prefixed[0xE6] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 4)) end
prefixed[0xE7] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 4) end

--SET 5

prefixed[0xE8] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 5) end
prefixed[0xE9] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 5) end
prefixed[0xEA] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 5) end
prefixed[0xEB] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 5) end
prefixed[0xEC] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 5) end
prefixed[0xED] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 5) end
prefixed[0xEE] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 5)) end
prefixed[0xEF] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 5) end

--SET 6

prefixed[0xF0] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 6) end
prefixed[0xF1] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 6) end
prefixed[0xF2] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 6) end
prefixed[0xF3] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 6) end
prefixed[0xF4] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 6) end
prefixed[0xF5] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 6) end
prefixed[0xF6] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 6)) end
prefixed[0xF7] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 6) end

--SET 7

prefixed[0xF8] = function (cpu) cpu.registers.b = SET(cpu, cpu.registers.b, 7) end
prefixed[0xF9] = function (cpu) cpu.registers.c = SET(cpu, cpu.registers.c, 7) end
prefixed[0xFA] = function (cpu) cpu.registers.d = SET(cpu, cpu.registers.d, 7) end
prefixed[0xFB] = function (cpu) cpu.registers.e = SET(cpu, cpu.registers.e, 7) end
prefixed[0xFC] = function (cpu) cpu.registers.h = SET(cpu, cpu.registers.h, 7) end
prefixed[0xFD] = function (cpu) cpu.registers.l = SET(cpu, cpu.registers.l, 7) end
prefixed[0xFE] = function (cpu) cpu.ram[cpu.registers:get_hl()] = (SET(cpu, cpu.ram[cpu.registers:get_hl()], 7)) end
prefixed[0xFF] = function (cpu) cpu.registers.a = SET(cpu, cpu.registers.a, 7) end

--yippee!

instructions[0xCB] = function(cpu)
    local byte = cpu:read_byte_pc_up()
    local opcode = opcodes.cbprefixed["0x" .. tohex(byte, 2)]
    if prefixed[byte] then
        print("executing PREFIX CB + " ..
            tohex(byte, 2) ..
            " | " .. opcode.mnemonic .. " " .. (opcode.operand1 or "") .. ", " .. (opcode.operand2 or ""))
        prefixed[byte](cpu)
    else
        print(colors("cannot find CB + " .. tohex(byte, 2)))
        instructions[0x76](cpu)
    end
end --Register opcode CB after all of the prefixed instructions

--Prefix CB end

return instructions
