local instructions = require("instructions")
local helpers = require("dmg.helpers")
local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

local ld = {}

-- LD r8, r8

local function ld_r8_r8(cpu, opcode)
    local source = band(opcode, 0b111) -- lower 3 bits are source
    local dest = band(rshift(opcode, 3), 0b111) --middle 3 bits are dest

    if source == 6 then -- loading from hl addr
        if cpu.current.cycle == 2 then
            cpu.current.temp = instructions.get_r8(cpu, source)
            return false -- we need another cycle please
        else
            instructions.set_r8(cpu, dest, cpu.current.temp)
        end
    elseif dest == 6 then -- loading to hl addr
        if cpu.current.cycle == 3 then
            instructions.set_r8(cpu, dest, instructions.get_r8(cpu, source))
        else
            return false -- wait one cycle please
        end
    else
        instructions.set_r8(cpu, dest, instructions.get_r8(cpu, source))
    end
end

local function generate_LD_r8_r8(opcodes)
    local x = 0b01 --LD r,r

    for y = 0, 7 do
        for z = 0, 7 do
            local opcode = instructions.assemble_opcode(x, y, z)
            opcodes[opcode] = ld_r8_r8
        end
    end
end

-- LD r8, d8

local function ld_r8_d8(cpu, opcode) -- TODO: fix timing so that (HL), d8 has M3
    local dest = band(rshift(opcode, 3), 0b111) --middle 3 bits are dest

    if cpu.current.cycle == 2 then
        cpu.current.temp = cpu.read_byte_pc_up()
        return false
    else
        instructions.set_r8(cpu, dest, cpu.current.temp)
    end
end

local function generate_LD_r8_d8(opcodes)
    local x = 0b00
    local z = 0b110

    for y = 0, 7 do
        local opcode = instructions.assemble_opcode(x, y, z)
        opcodes[opcode] = ld_r8_d8
    end
end

local function ld_r16_d16(cpu, opcode)
    local dest = band(rshift(opcode, 4), 0b11)

    if cpu.current.cycle == 2 then
        cpu.current.temp = cpu.read_byte_pc_up()
        return false
    elseif cpu.current.cycle == 3 then
        cpu.current.temp = helpers.unsigned_16(cpu.current.temp, cpu:read_byte_pc_up())
        instructions.set_r16(cpu, dest, cpu.current.temp)
    end
end

local function generate_LD_r16_d16(opcodes)
    local x = 0b00
    local z = 0b001

    for y = 0, 3 do
        local opcode = instructions.assemble_opcode(x, lshift(y, 1), z)

        opcodes[opcode] = ld_r16_d16
    end
end

local function ld_r16_a(cpu, opcode)
    local dest = band(rshift(opcode, 4), 0b11)

    instructions.set_r16_mem(cpu.registers.a)
end

local function generate_LD_r16_a(opcodes)
    local x = 0b00
    local z = 0b010

    for y = 0, 3 do
        local opcode = instructions.assemble_opcode(x, lshift(y, 1), z)
    end
end

local function ld_a_r16(cpu, opcode)
    local src = rshift(band(opcode, 0b111), 1)
    
    cpu.registers.a = get_r16_mem(src)
end

local function generate_LD_a_r16(opcodes)
    local x = 0b00
    local z = 0b010

    for y = 0, 3 do
        local opcode = instructions.assemble_opcode(x, bor(lshift(y, 1), 0b001))

        opcodes[opcode] = ld_a_r16
    end
end

local function ld_r16_sp(cpu, opcode)
    if cpu.current.cycle == 2 then
        cpu.current.temp = cpu:read_byte_pc_up()
        return false
    elseif cpu.current.cycle == 3 then
        cpu.current.temp = helpers.unsigned_16(cpu.current.temp, cpu:read_byte_pc_up())
        return false
    elseif cpu.current.cycle == 4 then
        cpu.ram[helpers.lsb(cpu.current.temp)] = helpers.lsb(cpu.registers:get_sp())
        return false
    elseif cpu.current.cycle == 5 then
        cpu.ram[helpers.msb(cpu.current.temp)] = helpers.msb(cpu.registers:get_sp())
    end
end

local function generate_LD_r16_sp(opcodes)
    local x = 0b00
    local y = 0b001
    local z = 0b000

    local opcode = instructions.assemble_opcode(x, y, z)

    opcodes[opcode] = ld_r16_sp
end

local function ldh_c_a(cpu, opcode)
    cpu.ram[cpu.registers.c] = cpu.registers.a
end

local function ldh_a_c(cpu, opcode)
    cpu.registers.a = cpu.ram[cpu.registers.c]
end

local function ldh_d8_a(cpu, opcode)
    if cpu.current.cycle == 2 then
        cpu.current.temp = bor(cpu:read_byte_pc_up(), 0xff00)
        return false
    elseif cpu.current.cycle == 3 then
        cpu.ram[cpu.current.temp] = cpu.registers.a
    end
end

local function ldh_a_d8(cpu, opcode)
    if cpu.current.cycle == 2 then
        cpu.current.temp = bor(cpu:read_byte_pc_up(), 0xff00)
        return false
    elseif cpu.current.cycle == 3 then
        cpu.registers.a = cpu.ram[cpu.current.temp]
    end
end

local function ld_d16_a(cpu, opcode)
    if cpu.current.cycle == 2 then
        cpu.current.temp = cpu:read_byte_pc_up()
        return false
    elseif cpu.current.cycle == 3 then
        cpu.current.temp = helpers.unsigned_16(cpu.current.temp, cpu:read_byte_pc_up())
        return false
    elseif cpu.current.cycle == 4 then
        cpu.ram[cpu.current.temp] = cpu.registers.a
    end
end

local function ld_a_d16(cpu, opcode)
    if cpu.current.cycle == 2 then
        cpu.current.temp = cpu:read_byte_pc_up()
        return false
    elseif cpu.current.cycle == 3 then
        cpu.current.temp = helpers.unsigned_16(cpu.current.temp, cpu:read_byte_pc_up())
        return false
    elseif cpu.current.cycle == 4 then
        cpu.registers.a = cpu.ram[cpu.current.temp]
    end
end

local function ld_hl_sp_d8(cpu, opcode)
    if cpu.current.cycle == 2 then
        cpu.current.temp = cpu:read_byte_pc_up()
        return false
    else
        cpu.registers:set_hl(band(cpu.registers:get_sp() + cpu.current.temp, 0xff))
    end
end

local function ld_sp_hl(cpu, opcode)
    cpu.registers:set_sp(cpu.registers:get_hl())
end

local function HALT(cpu, opcode)
    cpu.halt = true
end

local function generate_LD_others(opcodes)
    opcodes[0xe2] = ldh_c_a     -- 0b11100010
    opcodes[0xf2] = ldh_a_c     -- 0b11110010
    opcodes[0xe0] = ldh_d8_a    -- 0b11100000
    opcodes[0xf0] = ldh_a_d8    -- 0b11110000
    opcodes[0xea] = ld_d16_a    -- 0b11101010
    opcodes[0xfa] = ld_a_d16    -- 0b11111010
    opcodes[0xf8] = ld_hl_sp_d8 -- 0b11111000
    opcodes[0xf9] = ld_sp_hl    -- 0b11111001

    --this will overwrite ld r8,r8
    opcodes[0x76] = HALT
end

return ld