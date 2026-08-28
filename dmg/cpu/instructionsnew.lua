local instructions = {}
local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift,
    bit.tohex

local helpers = require("dmg.helpers")

--[[for i = 0, 0xff do
    instructions[i] = function(cpu)
        print("IMPLEMENT ME!!! " .. bit.tohex(i, 2) .. " @0x" .. bit.tohex(cpu.registers.pc, 4))
    end
end]]

local function signed_byte(val)
    if val > 127 then
        val = val - 256
    end
    return val + 1
end

function instructions.execute(cpu, opcode)
    print("Executing 0x"..bit.tohex(opcode, 2))
    return (instructions[opcode](cpu) ~= false)
end

local function mcycle(cpu, mult) --this is essentially a placeholder while i work on cpu
    mult = mult or 1
    cpu.tcycles = cpu.tcycles + (4 * mult)
end

local function read_memory(cpu, loc) -- ditto
    mcycle(cpu)
    return cpu.ram[loc]
end

local function write_memory(cpu, loc, val) -- ditto
    mcycle(cpu)
    cpu.ram[loc] = val
end

--LD, load instructions

--functions are in order of how i feel it should be
function LD_B(cpu, value) --                 LD B
    cpu.registers.b = value
end

instructions[0x06] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_B(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x40] = function(cpu)
    LD_B(cpu, cpu.registers.b)
    return true
end

instructions[0x41] = function(cpu)
    LD_B(cpu, cpu.registers.c)
    return true
end

instructions[0x42] = function(cpu)
    LD_B(cpu, cpu.registers.d)
    return true
end

instructions[0x43] = function(cpu)
    LD_B(cpu, cpu.registers.e)
    return true
end

instructions[0x44] = function(cpu)
    LD_B(cpu, cpu.registers.h)
    return true
end

instructions[0x45] = function(cpu)
    LD_B(cpu, cpu.registers.l)
    return true
end

instructions[0x46] = function(cpu)
    if cpu.current.cycle == 1 then
        local loc = cpu.registers:get_hl()
        cpu.current.temp = read_memory(cpu, loc)
    else
        LD_B(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x47] = function(cpu)
    LD_B(cpu, cpu.registers.a)
    return true
end

function LD_C(cpu, value) --                 LD C
    cpu.registers.c = value
end

instructions[0x0E] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_C(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x48] = function(cpu)
    LD_C(cpu, cpu.registers.b)
    return true
end

instructions[0x49] = function(cpu)
    LD_C(cpu, cpu.registers.c)
    return true
end

instructions[0x4A] = function(cpu)
    LD_C(cpu, cpu.registers.d)
    return true
end

instructions[0x4B] = function(cpu)
    LD_C(cpu, cpu.registers.e)
    return true
end

instructions[0x4C] = function(cpu)
    LD_C(cpu, cpu.registers.h)
    return true
end

instructions[0x4D] = function(cpu)
    LD_C(cpu, cpu.registers.l)
    return true
end

instructions[0x4E] = function(cpu)
    if cpu.current.cycle == 1 then
        local loc = cpu.registers:get_hl()
        cpu.current.temp = read_memory(cpu, loc)
    else
        LD_E(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x4F] = function(cpu)
    LD_C(cpu, cpu.registers.a)
    return true
end

function LD_D(cpu, value) --                 LD D
    cpu.registers.d = value
end

instructions[0x16] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_D(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x50] = function(cpu)
    LD_D(cpu, cpu.registers.b)
    return true
end

instructions[0x51] = function(cpu)
    LD_D(cpu, cpu.registers.c)
    return true
end

instructions[0x52] = function(cpu)
    LD_D(cpu, cpu.registers.d)
    return true
end

instructions[0x53] = function(cpu)
    LD_D(cpu, cpu.registers.e)
    return true
end

instructions[0x54] = function(cpu)
    LD_D(cpu, cpu.registers.h)
    return true
end

instructions[0x55] = function(cpu)
    LD_D(cpu, cpu.registers.l)
    return true
end

instructions[0x56] = function(cpu)
    if cpu.current.cycle == 1 then
        local loc = cpu.registers:get_hl()
        cpu.current.temp = read_memory(cpu, loc)
    else
        LD_D(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x57] = function(cpu)
    LD_D(cpu, cpu.registers.a)
    return true
end

function LD_E(cpu, value) --                 LD E
    cpu.registers.e = value
end

instructions[0x1E] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_E(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x58] = function(cpu)
    LD_E(cpu, cpu.registers.b)
    return true
end

instructions[0x59] = function(cpu)
    LD_E(cpu, cpu.registers.c)
    return true
end

instructions[0x5A] = function(cpu)
    LD_E(cpu, cpu.registers.d)
    return true
end

instructions[0x5B] = function(cpu)
    LD_E(cpu, cpu.registers.e)
    return true
end

instructions[0x5C] = function(cpu)
    LD_E(cpu, cpu.registers.h)
    return true
end

instructions[0x5D] = function(cpu)
    LD_E(cpu, cpu.registers.l)
    return true
end

instructions[0x5E] = function(cpu)
    if cpu.current.cycle == 1 then
        local loc = cpu.registers:get_hl()
        cpu.current.temp = read_memory(cpu, loc)
    else
        LD_E(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x5F] = function(cpu)
    LD_E(cpu, cpu.registers.a)
    return true
end

function LD_H(cpu, value) --                 LD H
    cpu.registers.h = value
end

instructions[0x26] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_H(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x60] = function(cpu)
    LD_H(cpu, cpu.registers.b)
    return true
end

instructions[0x61] = function(cpu)
    LD_H(cpu, cpu.registers.c)
    return true
end

instructions[0x62] = function(cpu)
    LD_H(cpu, cpu.registers.d)
    return true
end

instructions[0x63] = function(cpu)
    LD_H(cpu, cpu.registers.e)
    return true
end

instructions[0x64] = function(cpu)
    LD_H(cpu, cpu.registers.h)
    return true
end

instructions[0x65] = function(cpu)
    LD_H(cpu, cpu.registers.l)
    return true
end

instructions[0x66] = function(cpu)
    if cpu.current.cycle == 1 then
        local loc = cpu.registers:get_hl()
        cpu.current.temp = read_memory(cpu, loc)
    else
        LD_H(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x67] = function(cpu)
    LD_H(cpu, cpu.registers.a)
    return true
end

function LD_L(cpu, value) --                 LD L
    cpu.registers.l = value
end

instructions[0x2E] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_L(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x68] = function(cpu)
    LD_L(cpu, cpu.registers.b)
    return true
end

instructions[0x69] = function(cpu)
    LD_L(cpu, cpu.registers.c)
    return true
end

instructions[0x6A] = function(cpu)
    LD_L(cpu, cpu.registers.d)
    return true
end

instructions[0x6B] = function(cpu)
    LD_L(cpu, cpu.registers.e)
    return true
end

instructions[0x6C] = function(cpu)
    LD_L(cpu, cpu.registers.h)
    return true
end

instructions[0x6D] = function(cpu)
    LD_L(cpu, cpu.registers.l)
    return true
end

instructions[0x6E] = function(cpu)
    if cpu.current.cycle == 1 then
        local loc = cpu.registers:get_hl()
        cpu.current.temp = read_memory(cpu, loc)
    else
        LD_L(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x6F] = function(cpu)
    LD_L(cpu, cpu.registers.a)
    return true
end

function LD_AT_HL(cpu, value) --                 LD (HL)
    write_memory(cpu, cpu.registers:get_hl(), value)
end

instructions[0x36] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_AT_HL(cpu, val)
        return true
    end
end

instructions[0x70] = function(cpu)
    LD_AT_HL(cpu, cpu.registers.b)
    return true
end

instructions[0x71] = function(cpu)
    LD_AT_HL(cpu, cpu.registers.c)
    return true
end

instructions[0x72] = function(cpu)
    LD_AT_HL(cpu, cpu.registers.d)
    return true
end

instructions[0x73] = function(cpu)
    LD_AT_HL(cpu, cpu.registers.e)
    return true
end

instructions[0x74] = function(cpu)
    LD_AT_HL(cpu, cpu.registers.h)
    return true
end

instructions[0x75] = function(cpu)
    LD_AT_HL(cpu, cpu.registers.l)
    return true
end

-- 0x76 is HALT

instructions[0x77] = function(cpu)
    LD_AT_HL(cpu, cpu.registers.a)
    return true
end

function LD_A(cpu, value) --                 LD A
    cpu.registers.l = value
    return true
end

instructions[0x3E] = function(cpu)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        LD_A(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x78] = function(cpu)
    LD_A(cpu, cpu.registers.b)
    return true
end

instructions[0x79] = function(cpu)
    LD_A(cpu, cpu.registers.c)
    return true
end

instructions[0x7A] = function(cpu)
    LD_A(cpu, cpu.registers.d)
    return true
end

instructions[0x7B] = function(cpu)
    LD_A(cpu, cpu.registers.e)
    return true
end

instructions[0x7C] = function(cpu)
    LD_A(cpu, cpu.registers.h)
    return true
end

instructions[0x7D] = function(cpu)
    LD_A(cpu, cpu.registers.l)
    return true
end

instructions[0x7E] = function(cpu)
    if cpu.current.cycle == 1 then
        local loc = cpu.registers:get_hl()
        cpu.current.temp = read_memory(cpu, loc)
    else
        LD_A(cpu, cpu.current.temp)
        return true
    end
end

instructions[0x7F] = function(cpu)
    LD_A(cpu, cpu.registers.a)
    return true
end

-- Mem to A instrs

instructions[0x0A] = function(cpu)
    LD_A(cpu, read_memory(cpu, cpu.registers:get_bc()))
    return true
end

instructions[0x1A] = function(cpu)
    LD_A(cpu, read_memory(cpu, cpu.registers:get_de()))
    return true
end

instructions[0x2A] = function(cpu)
    local hl = cpu.registers:get_hl()
    LD_A(cpu, read_memory(cpu, hl))
    cpu.registers:set_hl(hl + 1)
    return true
end

instructions[0x3A] = function(cpu)
    local hl = cpu.registers:get_hl()
    LD_A(cpu, read_memory(cpu, hl))
    cpu.registers:set_hl(hl - 1)
    return true
end

-- A to mem instrs (reg, indirect)

instructions[0x02] = function(cpu)  -- LD (BC), A
    if cpu.current.cycle == 1 then
        write_memory(cpu, cpu.registers:get_bc(), cpu.registers.a)
        return true
    end
end

instructions[0x12] = function(cpu)  -- LD (DE), A
    if cpu.current.cycle == 1 then
        write_memory(cpu, cpu.registers:get_de(), cpu.registers.a)
        return true
    end
end

instructions[0x22] = function(cpu)  -- LD (HL+), A
    if cpu.current.cycle == 1 then
        cpu.registers:set_hl(cpu.registers:get_hl() + 1)
        write_memory(cpu, cpu.registers:get_bc(), cpu.registers.a)
        return true
    end
end

instructions[0x32] = function(cpu)  -- LD (HL-), A
    if cpu.current.cycle == 1 then
        cpu.registers:set_hl(cpu.registers:get_hl() - 1)
        write_memory(cpu, cpu.registers:get_bc(), cpu.registers.a)
        return true
    end
end

-- LD d8 to mem (HL, indirect)

instructions[0x36] = function(cpu)               -- LD (HL), d8
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up() -- store d8
    else
        write_memory(cpu, cpu.registers:get_hl(), cpu.current.temp)
        return true
    end
end

-- LD 16-bit instructions

-- LD rr, d16

instructions[0x01] = function(cpu)  -- LD BC, d16
    if cpu.current.cycle == 1 then
        cpu.current.temp = {}
        cpu.current.temp[1] = cpu:read_byte_pc_up()
    elseif cpu.current.cycle == 2 then
        cpu.current.temp[2] = cpu:read_byte_pc_up()

        cpu.registers:set_bc(band(lshift(cpu.current.temp[2], 8), cpu.current.temp[1]))
        return true
    end
end

instructions[0x11] = function(cpu)  -- LD DE, d16
    if cpu.current.cycle == 1 then
        cpu.current.temp = {}
        cpu.current.temp[1] = cpu:read_byte_pc_up()
    elseif cpu.current.cycle == 2 then
        cpu.current.temp[2] = cpu:read_byte_pc_up()

        cpu.registers:set_de(band(lshift(cpu.current.temp[2], 8), cpu.current.temp[1]))
        return true
    end
end

instructions[0x21] = function(cpu)  -- LD HL, d16
    if cpu.current.cycle == 1 then
        cpu.current.temp = {}
        cpu.current.temp[1] = cpu:read_byte_pc_up()
    elseif cpu.current.cycle == 2 then
        cpu.current.temp[2] = cpu:read_byte_pc_up()

        cpu.registers:set_hl(band(lshift(cpu.current.temp[2], 8), cpu.current.temp[1]))
        return true
    end
end

instructions[0x31] = function(cpu)  -- LD SP, d16
    if cpu.current.cycle == 1 then
        cpu.current.temp = {}
        cpu.current.temp[1] = cpu:read_byte_pc_up()
    elseif cpu.current.cycle == 2 then
        cpu.current.temp[2] = cpu:read_byte_pc_up()

        cpu.registers.sp = band(lshift(cpu.current.temp[2], 8), cpu.current.temp[1])
        return true
    end
end

-- LD rr, rr(*)

instructions[0xf8] = function(cpu)  -- LD HL, SP+r8
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    elseif cpu.current.cycle == 2 then
        cpu.registers:set_flag("z", false)
        cpu.registers.set_flag("n", false) -- it's not really documented when these are set
        cpu.registers:set_flag("hc", helpers.check_bit(cpu.current.temp, 3))
        cpu.registers:set_flag("c", helpers.check_bit(cpu.current.temp, 7))

        cpu.registers.l = cpu.current.temp
    else
        local msb = cpu:read_byte_pc_up()
        cpu.registers.h = msb
        return true
    end
end

instructions[0xf9] = function(cpu)              -- LD SP, HL
    cpu.registers.sp = bor(cpu.registers.hl, 0) -- just to prevent from setting reference
    return true
end

-- LDH

instructions[0xe0] = function(cpu)  -- LDH (0xFF00+d8), A
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        write_memory(cpu, helpers.unsigned_16(cpu.current.temp, 0xFF), cpu.registers.a)
        return true
    end
end

instructions[0xf0] = function(cpu)  -- LDH A, (0xFF00+d8)
    if cpu.current.cycle == 1 then
        cpu.current.temp = cpu:read_byte_pc_up()
    else
        cpu.registers.a = read_memory(helpers.unsigned_16(cpu.current.temp, 0xFF))
        return true
    end
end

-- PUSH/POP

-- PUSH
instructions[0xc5] = function(cpu)

end

instructions[0xd5] = function(cpu)

end

instructions[0xe5] = function(cpu)

end

instructions[0xf5] = function(cpu)

end

--Arithmetic instructions

function ADD_A(cpu, value) --                 ADD A
    local result = cpu.registers.a + value
    local result_clamped = band(result, 0xFF)

    local carry = (result > result_clamped) and 1 or 0
    local half_carry = ((band(result, 0xF) + band(result, 0xF)) > 0xF) and 1 or
    0                                                                             -- check if bits are moved from the lower nibble to the upper nibble
    cpu.registers:set_flag("c", carry)
    cpu.registers:set_flag("hc", half_carry)
    cpu.registers:set_flag("z", result_clamped % 2) -- result % 2 returns 0 if < 1

    cpu.registers.a = result_clamped
end

instructions[0x80] = function(cpu)
    ADD_A(cpu, cpu.instructions.b)
end

instructions[0x81] = function(cpu)
    ADD_A(cpu, cpu.instructions.c)
end

instructions[0x82] = function(cpu)
    ADD_A(cpu, cpu.instructions.d)
end

instructions[0x83] = function(cpu)
    ADD_A(cpu, cpu.instructions.e)
end

instructions[0x84] = function(cpu)
    ADD_A(cpu, cpu.instructions.h)
end

instructions[0x85] = function(cpu)
    ADD_A(cpu, cpu.instructions.l)
end

instructions[0x86] = function(cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    ADD_A(cpu, val)
end

instructions[0x87] = function(cpu)
    ADD_A(cpu, cpu.instructions.a)
end

instructions[0xC6] = function(cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    ADD_A(cpu, val)
end

function ADC_A(cpu, value)                          --                 ADC A
    ADD_A(cpu, value + cpu.registers:get_flag("c")) -- all we're doing that is different is adding the carry bit
end

instructions[0x88] = function(cpu)
    ADC_A(cpu, cpu.instructions.b)
end

instructions[0x89] = function(cpu)
    ADC_A(cpu, cpu.instructions.c)
end

instructions[0x8A] = function(cpu)
    ADC_A(cpu, cpu.instructions.d)
end

instructions[0x8B] = function(cpu)
    ADC_A(cpu, cpu.instructions.e)
end

instructions[0x8C] = function(cpu)
    ADC_A(cpu, cpu.instructions.h)
end

instructions[0x8D] = function(cpu)
    ADC_A(cpu, cpu.instructions.l)
end

instructions[0x8E] = function(cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    ADC_A(cpu, val)
end

instructions[0x8F] = function(cpu)
    ADC_A(cpu, cpu.instructions.a)
end

instructions[0xCE] = function(cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    ADC_A(cpu, val)
end

function SUB_A(cpu, value)

end

return instructions