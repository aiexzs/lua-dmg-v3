local instructions = {}
local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

for i = 0, 0xff do
    instructions[i] = function(cpu)
        print("IMPLEMENT ME!!! " .. bit.tohex(i, 2) .. " @0x" .. bit.tohex(cpu.registers.pc, 4))
    end
end

local function mcycle(cpu, mult)
    mult = mult or 1
    cpu.tcycles = cpu.tcycles + (4 * mult)
end

local function read_memory(cpu, loc)
    mcycle(cpu)
    return cpu.ram[loc]
end

local function write_memory(cpu, loc, val)
    mcycle(cpu)
    cpu.ram[loc] = val
end

--LD, load instructions

--functions are in order of how i feel it should be
function LD_B(cpu, value) --                 LD B
    cpu.registers.b = value
end

instructions[0x06] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_B(cpu, val)
end

instructions[0x40] = function (cpu)
    LD_B(cpu, cpu.registers.b)
end

instructions[0x41] = function (cpu)
    LD_B(cpu, cpu.registers.c)
end

instructions[0x42] = function (cpu)
    LD_B(cpu, cpu.registers.d)
end

instructions[0x43] = function (cpu)
    LD_B(cpu, cpu.registers.e)
end

instructions[0x44] = function (cpu)
    LD_B(cpu, cpu.registers.h)
end

instructions[0x45] = function (cpu)
    LD_B(cpu, cpu.registers.l)
end

instructions[0x46] = function (cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    LD_B(cpu, val)
end

instructions[0x47] = function (cpu)
    LD_B(cpu, cpu.registers.a)
end

function LD_C(cpu, value) --                 LD C
    cpu.registers.c = value
end

instructions[0x0E] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_C(cpu, val)
end

instructions[0x48] = function (cpu)
    LD_C(cpu, cpu.registers.b)
end

instructions[0x49] = function (cpu)
    LD_C(cpu, cpu.registers.c)
end

instructions[0x4A] = function (cpu)
    LD_C(cpu, cpu.registers.d)
end

instructions[0x4B] = function (cpu)
    LD_C(cpu, cpu.registers.e)
end

instructions[0x4C] = function (cpu)
    LD_C(cpu, cpu.registers.h)
end

instructions[0x4D] = function (cpu)
    LD_C(cpu, cpu.registers.l)
end

instructions[0x4E] = function (cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    LD_C(cpu, val)
end

instructions[0x4F] = function (cpu)
    LD_C(cpu, cpu.registers.a)
end

function LD_D(cpu, value) --                 LD D
    cpu.registers.d = value
end

instructions[0x16] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_D(cpu, val)
end

instructions[0x50] = function (cpu)
    LD_D(cpu, cpu.registers.b)
end

instructions[0x51] = function (cpu)
    LD_D(cpu, cpu.registers.c)
end

instructions[0x52] = function (cpu)
    LD_D(cpu, cpu.registers.d)
end

instructions[0x53] = function (cpu)
    LD_D(cpu, cpu.registers.e)
end

instructions[0x54] = function (cpu)
    LD_D(cpu, cpu.registers.h)
end

instructions[0x55] = function (cpu)
    LD_D(cpu, cpu.registers.l)
end

instructions[0x56] = function (cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    LD_D(cpu, val)
end

instructions[0x57] = function (cpu)
    LD_D(cpu, cpu.registers.a)
end

function LD_E(cpu, value) --                 LD E
    cpu.registers.e = value
end

instructions[0x1E] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_E(cpu, val)
end

instructions[0x58] = function (cpu)
    LD_E(cpu, cpu.registers.b)
end

instructions[0x59] = function (cpu)
    LD_E(cpu, cpu.registers.c)
end

instructions[0x5A] = function (cpu)
    LD_E(cpu, cpu.registers.d)
end

instructions[0x5B] = function (cpu)
    LD_E(cpu, cpu.registers.e)
end

instructions[0x5C] = function (cpu)
    LD_E(cpu, cpu.registers.h)
end

instructions[0x5D] = function (cpu)
    LD_E(cpu, cpu.registers.l)
end

instructions[0x5E] = function (cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    LD_E(cpu, val)
end

instructions[0x5F] = function (cpu)
    LD_E(cpu, cpu.registers.a)
end

function LD_H(cpu, value) --                 LD H
    cpu.registers.h = value
end

instructions[0x26] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_H(cpu, val)
end

instructions[0x60] = function (cpu)
    LD_H(cpu, cpu.registers.b)
end

instructions[0x61] = function (cpu)
    LD_H(cpu, cpu.registers.c)
end

instructions[0x62] = function (cpu)
    LD_H(cpu, cpu.registers.d)
end

instructions[0x63] = function (cpu)
    LD_H(cpu, cpu.registers.e)
end

instructions[0x64] = function (cpu)
    LD_H(cpu, cpu.registers.h)
end

instructions[0x65] = function (cpu)
    LD_H(cpu, cpu.registers.l)
end

instructions[0x66] = function (cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    LD_H(cpu, val)
end

instructions[0x67] = function (cpu)
    LD_H(cpu, cpu.registers.a)
end

function LD_L(cpu, value) --                 LD L
    cpu.registers.l = value
end

instructions[0x2E] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_L(cpu, val)
end

instructions[0x68] = function (cpu)
    LD_L(cpu, cpu.registers.b)
end

instructions[0x69] = function (cpu)
    LD_L(cpu, cpu.registers.c)
end

instructions[0x6A] = function (cpu)
    LD_L(cpu, cpu.registers.d)
end

instructions[0x6B] = function (cpu)
    LD_L(cpu, cpu.registers.e)
end

instructions[0x6C] = function (cpu)
    LD_L(cpu, cpu.registers.h)
end

instructions[0x6D] = function (cpu)
    LD_L(cpu, cpu.registers.l)
end

instructions[0x6E] = function (cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    LD_L(cpu, val)
end

instructions[0x6F] = function (cpu)
    LD_L(cpu, cpu.registers.a)
end

function LD_AT_HL(cpu, value) --                 LD (HL)
    write_memory(cpu, cpu.registers:get_hl(), value)
end

instructions[0x36] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_AT_HL(cpu, val)
end

instructions[0x70] = function (cpu)
    LD_AT_HL(cpu, cpu.registers.b)
end

instructions[0x71] = function (cpu)
    LD_AT_HL(cpu, cpu.registers.c)
end

instructions[0x72] = function (cpu)
    LD_AT_HL(cpu, cpu.registers.d)
end

instructions[0x73] = function (cpu)
    LD_AT_HL(cpu, cpu.registers.e)
end

instructions[0x74] = function (cpu)
    LD_AT_HL(cpu, cpu.registers.h)
end

instructions[0x75] = function (cpu)
    LD_AT_HL(cpu, cpu.registers.l)
end

-- 0x76 is HALT

instructions[0x77] = function (cpu)
    LD_AT_HL(cpu, cpu.registers.a)
end

function LD_A(cpu, value) --                 LD A
    cpu.registers.l = value
end

instructions[0x3E] = function (cpu)
    local val = cpu:read_byte_pc_up()
    mcycle(cpu)
    LD_A(cpu, val)
end

instructions[0x78] = function (cpu)
    LD_A(cpu, cpu.registers.b)
end

instructions[0x79] = function (cpu)
    LD_A(cpu, cpu.registers.c)
end

instructions[0x7A] = function (cpu)
    LD_A(cpu, cpu.registers.d)
end

instructions[0x7B] = function (cpu)
    LD_A(cpu, cpu.registers.e)
end

instructions[0x7C] = function (cpu)
    LD_A(cpu, cpu.registers.h)
end

instructions[0x7D] = function (cpu)
    LD_A(cpu, cpu.registers.l)
end

instructions[0x7E] = function (cpu)
    local loc = cpu.registers:get_hl()
    local val = read_memory(cpu, loc)
    LD_A(cpu, val)
end

instructions[0x7F] = function (cpu)
    LD_A(cpu, cpu.registers.a)
end

-- Mem to A instrs

instructions[0x0A] = function (cpu)
    LD_A(cpu, read_memory(cpu, cpu.registers:get_bc()))
end

instructions[0x1A] = function (cpu)
    LD_A(cpu, read_memory(cpu, cpu.registers:get_de()))
end

instructions[0x2A] = function (cpu)
    local hl = cpu.registers:get_hl()
    LD_A(cpu, read_memory(cpu, hl))
    cpu.registers:set_hl(hl+1)
end

instructions[0x3A] = function (cpu)
    local hl = cpu.registers:get_hl()
    LD_A(cpu, read_memory(cpu, hl))
    cpu.registers:set_hl(hl-1)
end

-- A to mem instrs

instructions[0x02] = function (cpu)
    write_memory(cpu, cpu.registers:get_bc(), cpu.registers.a)
end

instructions[0x12] = function (cpu)
    write_memory(cpu, cpu.registers:get_de(), cpu.registers.a)
end

instructions[0x22] = function (cpu)
    local hl = cpu.registers:get_hl()
    write_memory(cpu, hl, cpu.registers.a)
    cpu.registers:set_hl(hl+1)
end

instructions[0x32] = function (cpu)
    local hl = cpu.registers:get_hl()
    write_memory(cpu, hl, cpu.registers.a)
    cpu.registers:set_hl(hl-1)
end

--Arithmetic instructions

function ADD_A(cpu, value)
    local result = cpu.registers.a + value
    cpu.registers:
end

instructions[0x80] = function (cpu)
    
end