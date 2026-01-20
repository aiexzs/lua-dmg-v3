local instructions = {}
local opcodes = require("dmg.opcodes")

local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

instructions[0x00] = function (cpu) cpu.cycles = cpu.cycles * 1 end

--LD: Load instructions

instructions[0x01] = function (cpu) cpu.registers:set_bc(cpu:read_u16_pc_up()) end
instructions[0x02] = function (cpu) cpu.ram[cpu.registers:get_bc()] = cpu.registers.a end
instructions[0x06] = function (cpu) cpu.registers.b = cpu:read_byte_pc_up() end
instructions[0x08] = function (cpu) cpu.ram[cpu:read_u16_pc_up()] = cpu.registers.sp end
instructions[0x0a] = function (cpu) cpu.registers.a = cpu.ram[cpu.registers:get_bc()] end
instructions[0x0e] = function (cpu) cpu.registers.c = cpu:read_byte_pc_up() end
instructions[0x11] = function (cpu) cpu.registers:set_de(cpu:read_u16_pc_up()) end
instructions[0x12] = function (cpu) cpu.ram[cpu.registers:get_de()] = cpu.registers.a end
instructions[0x16] = function (cpu) cpu.registers.d = cpu:read_byte_pc_up() end
instructions[0x1a] = function (cpu) cpu.registers.a = cpu.ram[cpu.registers:get_de()] end
instructions[0x1e] = function (cpu) cpu.registers.e = cpu:read_byte_pc_up() end
instructions[0x21] = function (cpu) cpu.registers:set_hl(cpu:read_u16_pc_up()) end
instructions[0x22] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.a;cpu.registers:set_hl(cpu.registers:get_hl()+1) end
instructions[0x26] = function (cpu) cpu.registers.h = cpu:read_byte_pc_up() end
instructions[0x2a] = function (cpu) cpu.registers.a = cpu.ram[cpu.registers:get_hl()];cpu.registers:set_hl(cpu.registers:get_hl()+1) end
instructions[0x2e] = function (cpu) cpu.registers.l = cpu:read_byte_pc_up() end
instructions[0x31] = function (cpu) cpu.registers.sp = cpu:read_u16_pc_up() end
instructions[0x32] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.a;cpu.registers:set_hl(cpu.registers:get_hl()-1) end
instructions[0x36] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu:read_byte_pc_up() end
instructions[0x3a] = function (cpu) cpu.registers.a = cpu.ram[cpu.registers:get_hl()];cpu.registers:set_hl(cpu.registers:get_hl()-1) end
instructions[0x3e] = function (cpu) cpu.registers.a = cpu:read_byte_pc_up() end
--register-to-register load instructions
instructions[0x40] = function (cpu) cpu.registers.b = cpu.registers.b end
instructions[0x41] = function (cpu) cpu.registers.b = cpu.registers.c end
instructions[0x42] = function (cpu) cpu.registers.b = cpu.registers.d end
instructions[0x43] = function (cpu) cpu.registers.b = cpu.registers.e end
instructions[0x44] = function (cpu) cpu.registers.b = cpu.registers.h end
instructions[0x45] = function (cpu) cpu.registers.b = cpu.registers.l end
instructions[0x46] = function (cpu) cpu.registers.b = cpu.ram[cpu.registers:get_hl()] end
instructions[0x47] = function (cpu) cpu.registers.b = cpu.registers.a end
instructions[0x48] = function (cpu) cpu.registers.c = cpu.registers.b end
instructions[0x49] = function (cpu) cpu.registers.c = cpu.registers.c end
instructions[0x4a] = function (cpu) cpu.registers.c = cpu.registers.d end
instructions[0x4b] = function (cpu) cpu.registers.c = cpu.registers.e end
instructions[0x4c] = function (cpu) cpu.registers.c = cpu.registers.h end
instructions[0x4d] = function (cpu) cpu.registers.c = cpu.registers.l end
instructions[0x4e] = function (cpu) cpu.registers.c = cpu.ram[cpu.registers:get_hl()] end
instructions[0x4f] = function (cpu) cpu.registers.c = cpu.registers.a end
instructions[0x50] = function (cpu) cpu.registers.d = cpu.registers.b end
instructions[0x51] = function (cpu) cpu.registers.d = cpu.registers.c end
instructions[0x52] = function (cpu) cpu.registers.d = cpu.registers.d end
instructions[0x53] = function (cpu) cpu.registers.d = cpu.registers.e end
instructions[0x54] = function (cpu) cpu.registers.d = cpu.registers.h end
instructions[0x55] = function (cpu) cpu.registers.d = cpu.registers.l end
instructions[0x56] = function (cpu) cpu.registers.d = cpu.ram[cpu.registers:get_hl()] end
instructions[0x57] = function (cpu) cpu.registers.d = cpu.registers.a end
instructions[0x58] = function (cpu) cpu.registers.e = cpu.registers.b end
instructions[0x59] = function (cpu) cpu.registers.e = cpu.registers.c end
instructions[0x5a] = function (cpu) cpu.registers.e = cpu.registers.d end
instructions[0x5b] = function (cpu) cpu.registers.e = cpu.registers.e end
instructions[0x5c] = function (cpu) cpu.registers.e = cpu.registers.h end
instructions[0x5d] = function (cpu) cpu.registers.e = cpu.registers.l end
instructions[0x5e] = function (cpu) cpu.registers.e = cpu.ram[cpu.registers:get_hl()] end
instructions[0x5f] = function (cpu) cpu.registers.e = cpu.registers.a end
instructions[0x60] = function (cpu) cpu.registers.h = cpu.registers.b end
instructions[0x61] = function (cpu) cpu.registers.h = cpu.registers.c end
instructions[0x62] = function (cpu) cpu.registers.h = cpu.registers.d end
instructions[0x63] = function (cpu) cpu.registers.h = cpu.registers.e end
instructions[0x64] = function (cpu) cpu.registers.h = cpu.registers.h end
instructions[0x65] = function (cpu) cpu.registers.h = cpu.registers.l end
instructions[0x66] = function (cpu) cpu.registers.h = cpu.ram[cpu.registers:get_hl()] end
instructions[0x67] = function (cpu) cpu.registers.h = cpu.registers.a end
instructions[0x68] = function (cpu) cpu.registers.l = cpu.registers.b end
instructions[0x69] = function (cpu) cpu.registers.l = cpu.registers.c end
instructions[0x6a] = function (cpu) cpu.registers.l = cpu.registers.d end
instructions[0x6b] = function (cpu) cpu.registers.l = cpu.registers.e end
instructions[0x6c] = function (cpu) cpu.registers.l = cpu.registers.h end
instructions[0x6d] = function (cpu) cpu.registers.l = cpu.registers.l end
instructions[0x6e] = function (cpu) cpu.registers.l = cpu.ram[cpu.registers:get_hl()] end
instructions[0x6f] = function (cpu) cpu.registers.l = cpu.registers.a end
instructions[0x70] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.b end
instructions[0x71] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.c end
instructions[0x72] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.d end
instructions[0x73] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.e end
instructions[0x74] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.h end
instructions[0x75] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.l end
instructions[0x77] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.registers.a end
instructions[0x78] = function (cpu) cpu.registers.a = cpu.registers.b end
instructions[0x79] = function (cpu) cpu.registers.a = cpu.registers.c end
instructions[0x7a] = function (cpu) cpu.registers.a = cpu.registers.d end
instructions[0x7b] = function (cpu) cpu.registers.a = cpu.registers.e end
instructions[0x7c] = function (cpu) cpu.registers.a = cpu.registers.h end
instructions[0x7d] = function (cpu) cpu.registers.a = cpu.registers.l end
instructions[0x7e] = function (cpu) cpu.registers.a = cpu.ram[cpu.registers:get_hl()] end
instructions[0x7f] = function (cpu) cpu.registers.a = cpu.registers.a end

instructions[0xe2] = function (cpu) cpu.ram[0xff00+cpu.registers.c] = cpu.registers.a end
instructions[0xea] = function (cpu) cpu.ram[cpu:read_u16_pc_up()] = cpu.registers.a end
instructions[0xf2] = function (cpu) cpu.registers.a = cpu.ram[cpu.registers.c] end
instructions[0xf8] = function (cpu) cpu.registers:set_hl(cpu.registers.sp+cpu:read_byte_pc_up()) end
instructions[0xf9] = function (cpu) cpu.registers.sp = cpu.registers:get_hl() end
instructions[0xfa] = function (cpu) cpu.registers.a = cpu.ram[cpu:read_u16_pc_up()] end

--LDH: Load instructions +0xFF00

instructions[0xe0] = function (cpu) cpu.ram[0xFF00+cpu:read_byte_pc_up()] = cpu.registers.a end
instructions[0xf0] = function (cpu) cpu.registers.a = cpu.ram[0xFF00+cpu:read_byte_pc_up()] end

--Arithmetic instructions

--ADD

local function setIncFlags(cpu, value)
    cpu.registers:set_flag("z", value == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", value % 0x10 == 0x0)
end

local function setDecFlags(cpu, value)
    cpu.registers:set_flag("z", value == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", value % 0x10 == 0x0)
end

local function addA(cpu, v) 
    local a = cpu.registers.a
    local result = (a + v)
    local wrapped = band(result, 0b11111111)

    cpu.registers.a = wrapped
    
    cpu.registers:set_flag("z", wrapped == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", (band(a, 0xF) + band(v, 0xF)) > 0xF)
end

local function subA(cpu, v)
    local result = cpu.registers.a - v
    cpu.registers.a = result

    cpu.registers:set_flag("z", result == 0)
    cpu.registers:set_flag("n", true)
end

instructions[0x09] = function (cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers:get_bc()) end
instructions[0x19] = function (cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers:get_de()) end
instructions[0x29] = function (cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers:get_hl()) end
instructions[0x39] = function (cpu) cpu.registers:set_hl(cpu.registers:get_hl() + cpu.registers.sp) end
instructions[0x80] = function (cpu) addA(cpu, cpu.registers.b) end
instructions[0x81] = function (cpu) addA(cpu, cpu.registers.c) end
instructions[0x82] = function (cpu) addA(cpu, cpu.registers.d) end
instructions[0x83] = function (cpu) addA(cpu, cpu.registers.e) end
instructions[0x84] = function (cpu) addA(cpu, cpu.registers.h) end
instructions[0x85] = function (cpu) addA(cpu, cpu.registers.l) end
instructions[0x86] = function (cpu) addA(cpu, cpu.ram[cpu.registers:get_hl()]) end
instructions[0x87] = function (cpu) addA(cpu, cpu.registers.a) end
instructions[0xc6] = function (cpu) cpu.registers.a = cpu.registers.a + cpu:read_byte_pc_up() end
instructions[0xe8] = function (cpu) cpu.registers.sp = cpu.registers.sp + cpu:read_byte_pc_up() end

--ADC

instructions[0x88] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.registers.b + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0x89] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.registers.c + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0x8a] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.registers.d + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0x8b] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.registers.e + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0x8c] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.registers.h + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0x8d] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.registers.l + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0x8e] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.ram[cpu.registers:get_hl()] + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0x8f] = function (cpu) cpu.registers.a = cpu.registers.a + cpu.registers.a + (cpu.registers:get_flag("c") and 1 or 0) end
instructions[0xce] = function (cpu) cpu.registers.a = cpu.registers.a + cpu:read_byte_pc_up() + (cpu.registers:get_flag("c") and 1 or 0) end

--SUB

instructions[0x90] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.b end
instructions[0x91] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.c end
instructions[0x92] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.d end
instructions[0x93] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.e end
instructions[0x94] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.h end
instructions[0x95] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.l end
instructions[0x96] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.ram[cpu.registers:get_hl()] end
instructions[0x97] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.a end
instructions[0xd6] = function (cpu) cpu.registers.a = cpu.registers.a - cpu:read_byte_pc_up() end

--SBC

instructions[0x98] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.b - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0x99] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.c - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0x9a] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.d - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0x9b] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.e - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0x9c] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.h - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0x9d] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.l - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0x9e] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.ram[cpu.registers:get_hl()] - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0x9f] = function (cpu) cpu.registers.a = cpu.registers.a - cpu.registers.a - (cpu.registers:get_flag("z") and 1 or 0) end
instructions[0xde] = function (cpu) cpu.registers.a = cpu.registers.a - cpu:read_byte_pc_up() - (cpu.registers:get_flag("z") and 1 or 0) end

--INC

instructions[0x03] = function (cpu) cpu.registers:set_bc(cpu.registers:get_bc() + 1) end
instructions[0x04] = function (cpu) cpu.registers.b = cpu.registers.b + 1;setIncFlags(cpu, cpu.registers.b) end
instructions[0x0c] = function (cpu) cpu.registers.c = cpu.registers.c + 1;setIncFlags(cpu, cpu.registers.c) end

instructions[0x13] = function (cpu) cpu.registers:set_de(cpu.registers:get_de() + 1) end
instructions[0x14] = function (cpu) cpu.registers.d = cpu.registers.d + 1;setIncFlags(cpu, cpu.registers.d) end
instructions[0x1c] = function (cpu) cpu.registers.e = cpu.registers.e + 1;setIncFlags(cpu, cpu.registers.e) end

instructions[0x23] = function (cpu) cpu.registers:set_hl(cpu.registers:get_hl() + 1) end
instructions[0x24] = function (cpu) cpu.registers.h = cpu.registers.h + 1;setIncFlags(cpu, cpu.registers.h) end
instructions[0x2c] = function (cpu) cpu.registers.l = cpu.registers.l + 1;setIncFlags(cpu, cpu.registers.l) end

instructions[0x33] = function (cpu) cpu.registers.sp = cpu.registers.sp + 1;setIncFlags(cpu, cpu.registers.sp) end
instructions[0x34] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.ram[cpu.registers:get_hl()] + 1 end
instructions[0x3c] = function (cpu) cpu.registers.a = cpu.registers.a + 1;setIncFlags(cpu, cpu.registers.a) end

--DEC

instructions[0x05] = function (cpu) cpu.registers.b = cpu.registers.b - 1;setDecFlags(cpu, cpu.registers.b) end
instructions[0x0b] = function (cpu) cpu.registers:set_bc(cpu.registers:get_bc() - 1);setDecFlags(cpu, cpu.registers:get_bc()) end
instructions[0x0d] = function (cpu) cpu.registers.c = cpu.registers.c - 1;setDecFlags(cpu, cpu.registers.c) end

instructions[0x15] = function (cpu) cpu.registers.d = cpu.registers.d - 1;setDecFlags(cpu, cpu.registers.d) end
instructions[0x1b] = function (cpu) cpu.registers:set_de(cpu.registers:get_de() - 1);setDecFlags(cpu, cpu.registers:get_de()) end
instructions[0x1d] = function (cpu) cpu.registers.e = cpu.registers.e - 1;setDecFlags(cpu, cpu.registers.e) end

instructions[0x25] = function (cpu) cpu.registers.h = cpu.registers.h - 1;setDecFlags(cpu, cpu.registers.h) end
instructions[0x2b] = function (cpu) cpu.registers:set_hl(cpu.registers:get_hl() - 1);setDecFlags(cpu, cpu.registers:get_hl()) end
instructions[0x2d] = function (cpu) cpu.registers.l = cpu.registers.l - 1;setDecFlags(cpu, cpu.registers.l) end

instructions[0x35] = function (cpu) cpu.ram[cpu.registers:get_hl()] = cpu.ram[cpu.registers:get_hl()] - 1;setDecFlags(cpu, cpu.ram[cpu.registers:get_hl()]) end
instructions[0x3b] = function (cpu) cpu.registers.sp = cpu.registers.sp - 1;setDecFlags(cpu, cpu.registers.sp) end
instructions[0x3d] = function (cpu) cpu.registers.a = cpu.registers.a - 1;setDecFlags(cpu, cpu.registers.a) end

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

instructions[0xa0] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xa1] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xa2] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xa3] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xa4] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xa5] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xa6] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xa7] = function (cpu) cpu.registers.a = andFlags(cpu, cpu.registers.a, cpu.registers.a) end

--XOR

instructions[0xa8] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xa9] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xaa] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xab] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xac] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xad] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xae] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xaf] = function (cpu) cpu.registers.a = xorFlags(cpu, cpu.registers.a, cpu.registers.a) end

--OR

instructions[0xb0] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xb1] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xb2] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xb3] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xb4] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xb5] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xb6] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xb7] = function (cpu) cpu.registers.a = orFlags(cpu, cpu.registers.a, cpu.registers.a) end

--CP

instructions[0xb8] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.b) end
instructions[0xb9] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.c) end
instructions[0xba] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.d) end
instructions[0xbb] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.e) end
instructions[0xbc] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.h) end
instructions[0xbd] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.l) end
instructions[0xbe] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.ram[cpu.registers:get_hl()]) end
instructions[0xbf] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu.registers.a) end
instructions[0xfe] = function (cpu) cpFlags(cpu, cpu.registers.a, cpu:read_byte_pc_up()) end

--Misc Arithmetic Instructions

--DAA (TODO)

instructions[0x37] = function (cpu) --SCF (set carry)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)
    cpu.registers:set_flag("c", true)
end

instructions[0x2f] = function (cpu) --CPL (flip a)
    cpu.registers.a = bnot(cpu.registers.a)
    cpu.registers:set_flag("n", true)
    cpu.registers:set_flag("hc", true)
end

instructions[0x3f] = function (cpu) --CCF (flip carry)
    cpu.registers:set_flag("c", not cpu.registers:get_flag("c"))
end

--Jump/call instructions

--JP

instructions[0xc2] = function (cpu) if not cpu.registers:get_flag("z") then cpu.registers.pc = cpu:read_u16_pc_up() end end --NZ
instructions[0xc3] = function (cpu) cpu.registers.pc = cpu:read_u16_pc_up() end
instructions[0xca] = function (cpu) if cpu.registers:get_flag("z") then cpu.registers.pc = cpu:read_u16_pc_up() end end --Z
instructions[0xd2] = function (cpu) if not cpu.registers:get_flag("c") then cpu.registers.pc = cpu:read_u16_pc_up() end end --NC
instructions[0xda] = function (cpu) if cpu.registers:get_flag("c") then cpu.registers.pc = cpu:read_u16_pc_up() end end --C
instructions[0xe9] = function (cpu) cpu.registers.pc = cpu.registers:get_hl() end

--JR

local function signed_byte(val)
    if val > 127 then
        val = val - 256
    end
    return val+1
end

instructions[0x18] = function (cpu) cpu.registers.pc = cpu.registers.pc + signed_byte(cpu:read_byte_pc_up()) end
instructions[0x20] = function (cpu) if not cpu.registers:get_flag("z") then cpu.registers.pc = cpu.registers.pc + signed_byte(cpu:read_byte_pc_up()) else cpu:read_byte_pc_up() print("z") end end --NZ
instructions[0x28] = function (cpu) if cpu.registers:get_flag("z") then cpu.registers.pc = cpu.registers.pc + signed_byte(cpu:read_byte_pc_up()) else cpu:read_byte_pc_up() end end --Z
instructions[0x30] = function (cpu) if not cpu.registers:get_flag("c") then cpu.registers.pc = cpu.registers.pc + signed_byte(cpu:read_byte_pc_up()) else cpu:read_byte_pc_up() end end --NC
instructions[0x38] = function (cpu) if cpu.registers:get_flag("c") then cpu.registers.pc = cpu.registers.pc + signed_byte(cpu:read_byte_pc_up()) else cpu:read_byte_pc_up() end end --C

--CALL

instructions[0xc4] = function (cpu) if not cpu.registers:get_flag("z") then cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up() end end
instructions[0xcc] = function (cpu) if cpu.registers:get_flag("z") then cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up() end end
instructions[0xcd] = function (cpu) cpu:write_u16_sp_down(cpu.registers.pc+1); cpu.registers.pc = cpu:read_u16_pc_up() end 
instructions[0xd4] = function (cpu) if not cpu.registers:get_flag("c") then cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up() end end
instructions[0xdc] = function (cpu) if cpu.registers:get_flag("c") then cpu:write_u16_sp_down(cpu.registers.pc); cpu.registers.pc = cpu:read_u16_pc_up() end end

--RET

instructions[0xc9] = function (cpu) cpu.registers.pc = cpu:read_u16_sp_up() end

--Stack instructions (POP/PUSH)

--POP

instructions[0xc1] = function (cpu) cpu.registers:set_bc(cpu:read_u16_sp_up()) end
instructions[0xd1] = function (cpu) cpu.registers:set_de(cpu:read_u16_sp_up()) end
instructions[0xe1] = function (cpu) cpu.registers:set_hl(cpu:read_u16_sp_up()) end
instructions[0xf1] = function (cpu) cpu.registers:set_af(cpu:read_u16_sp_up()) end

--PUSH

instructions[0xc5] = function (cpu) cpu:write_u16_sp_down(cpu.registers:get_bc()) end
instructions[0xd5] = function (cpu) cpu:write_u16_sp_down(cpu.registers:get_de()) end
instructions[0xe5] = function (cpu) cpu:write_u16_sp_down(cpu.registers:get_hl()) end
instructions[0xf5] = function (cpu) cpu:write_u16_sp_down(cpu.registers:get_af()) end

--Bitwise instructions

--RLA

local function rl_c(cpu, value) -- rotate left through carry
    local carry = rshift(value, 7) -- Extract carry as 1 or 0
    value = band(lshift(value, 1), 0b11111111) -- Rotate left and mask to 8 bits
    value = bor(value, (cpu.registers:get_flag("c") and 1 or 0)) -- Add old carry to LSB
    cpu.registers:set_flag("c", carry ~= 0) -- Set carry flag
    return value
end


instructions[0x17] = function (cpu) cpu.registers.a = rl_c(cpu, cpu.registers.a) end

--[[
    Begin Prefix CB instructions
    Byte ahead of opcode CB is prefixed instruction
    for example 0xCB 0x7C is BIT 7,H
]]

local prefixed = {}

local function rlc(cpu, value)
    local bit7 = bit.rshift(value, 7)
    cpu.registers:set_flag("c", bit7 == 1)
    
    value = bit.lshift(value, 1)
    value = bit.bor(value, bit7) -- union old bit 7 to copy it to new bit 0
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
    value = bit.band(value, 0b11111111) -- keep it within 8 bits

    cpu.registers:set_flag("z", value == 0)
    cpu.registers:set_flag("n", false)
    cpu.registers:set_flag("hc", false)

    return value
end

--RLC r

prefixed[0x00] = function (cpu) cpu.registers.b = rlc(cpu, cpu.registers.b) end
prefixed[0x01] = function (cpu) cpu.registers.c = rlc(cpu, cpu.registers.c) end
prefixed[0x02] = function (cpu) cpu.registers.d = rlc(cpu, cpu.registers.d) end
prefixed[0x03] = function (cpu) cpu.registers.e = rlc(cpu, cpu.registers.e) end
prefixed[0x04] = function (cpu) cpu.registers.h = rlc(cpu, cpu.registers.h) end
prefixed[0x05] = function (cpu) cpu.registers.l = rlc(cpu, cpu.registers.l) end
prefixed[0x06] = function (cpu) cpu:set_hl(rlc(cpu, cpu:get_hl())) end
prefixed[0x07] = function (cpu) cpu.registers.a = rlc(cpu, cpu.registers.a) end

--RRC r

prefixed[0x08] = function (cpu) cpu.registers.b = rrc(cpu, cpu.registers.b) end
prefixed[0x09] = function (cpu) cpu.registers.c = rrc(cpu, cpu.registers.c) end
prefixed[0x0a] = function (cpu) cpu.registers.d = rrc(cpu, cpu.registers.d) end
prefixed[0x0b] = function (cpu) cpu.registers.e = rrc(cpu, cpu.registers.e) end
prefixed[0x0c] = function (cpu) cpu.registers.h = rrc(cpu, cpu.registers.h) end
prefixed[0x0d] = function (cpu) cpu.registers.l = rrc(cpu, cpu.registers.l) end
prefixed[0x0e] = function (cpu) cpu:set_hl(rrc(cpu, cpu:get_hl())) end
prefixed[0x0f] = function (cpu) cpu.registers.a = rrc(cpu, cpu.registers.a) end

prefixed[0x10] = function (cpu) cpu.registers.b = rl_c(cpu, cpu.registers.b) end
prefixed[0x11] = function (cpu) cpu.registers.c = rl_c(cpu, cpu.registers.c) end
prefixed[0x12] = function (cpu) cpu.registers.d = rl_c(cpu, cpu.registers.d) end
prefixed[0x13] = function (cpu) cpu.registers.e = rl_c(cpu, cpu.registers.e) end

local function swap(val)
    local upper = rshift(band(val, 0b11110000), 4)
    local lower = band(0b00001111, val)
    val = band(lshift(lower,4), upper)
    return val
end

prefixed[0x37] = function (cpu) cpu.registers.a = swap(cpu.registers.a) end

prefixed[0x7C] = function (cpu) cpu.registers:set_flag('z', band(cpu.registers.h, 0b10000000) == 0) end --Set zero flag to result of band (operand2, 2^operand1) so this case band (registers.h, 2^7)

instructions[0xCB] = function (cpu) 
    local byte = cpu:read_byte_pc_up()
    local opcode = opcodes.cbprefixed["0x"..tohex(byte, 2)]
    if prefixed[byte] then
        print("executing PREFIX CB + "..tohex(byte, 2).." | "..opcode.mnemonic.." "..(opcode.operand1 or "")..", "..(opcode.operand2 or ""))
        prefixed[byte](cpu) 
    else
        print(colors("cannot find CB + "..tohex(byte, 2)))
    end
end --Register opcode CB after all of the prefixed instructions

--Prefix CB end

return instructions