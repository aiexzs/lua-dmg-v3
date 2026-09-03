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
    --print("Executing 0x"..bit.tohex(opcode, 2))
    return (instructions[opcode](cpu) ~= false)
end

function instructions.generate(self)

end

function instructions.assemble_opcode(xx, yyy, zzz)
    return bor(lshift(xx, 6), bor(lshift(yyy, 3), zzz))
end

-- r8 getter/setter

function instructions.get_r8(cpu, r)
    if r == 0 then return cpu.registers.b end
    if r == 1 then return cpu.registers.c end
    if r == 2 then return cpu.registers.d end
    if r == 3 then return cpu.registers.e end
    if r == 4 then return cpu.registers.h end
    if r == 5 then return cpu.registers.l end
    if r == 6 then return cpu.ram[cpu.registers:get_hl()] end
    if r == 7 then return cpu.registers.a end
end

function instructions.set_r8(cpu, r, value)
    if r == 0 then cpu.registers.b = value
    elseif r == 1 then cpu.registers.c = value
    elseif r == 2 then cpu.registers.d = value
    elseif r == 3 then cpu.registers.e = value
    elseif r == 4 then cpu.registers.h = value
    elseif r == 5 then cpu.registers.l = value
    elseif r == 6 then cpu.ram[cpu:get_hl()] = value
    elseif r == 7 then cpu.registers.a = value
    end
end

-- r16 getter/setter

function instructions.get_r16(cpu, r, stk) -- stk swaps sp to af which is literally only used for push/pop so using it here avoids repetition
    if r == 0 then return cpu.registers:get_bc()
    elseif r == 1 then return cpu.registers:get_de()
    elseif r == 2 then return cpu.registers:get_hl()
    elseif r == 3 then return (stk and cpu.registers.get_af() or cpu.registers:get_sp())
    end
end

function instructions.set_r16(cpu, r, value, stk)
    if r == 0 then return cpu.registers:set_bc(value)
    elseif r == 1 then return cpu.registers:set_de(value)
    elseif r == 2 then return cpu.registers:set_hl(value)
    elseif r == 3 and stk then cpu.registers:set_af(value)
    elseif r == 3 then cpu.registers:set_sp(value)
    end
end

-- r16mem getter/setter

local function get_hl_inc(cpu)
    local hl = cpu.registers:get_hl()
    cpu.registers:set_hl(hl + 1)
    return hl
end

local function get_hl_dec(cpu)
    local hl = cpu.registers:get_hl()
    cpu.registers:set_hl(hl - 1)
    return hl
end

function instructions.get_r16_mem(cpu, r)
    if r == 0 then return cpu.ram[cpu.registers:get_bc()]
    elseif r == 1 then return cpu.ram[cpu.registers:get_de()]
    elseif r == 2 then return cpu.ram[get_hl_inc(cpu)]
    elseif r == 3 then return cpu.ram[get_hl_dec(cpu)]
    end
end

function instructions.set_r16_mem(cpu, r, value)
    if r == 0 then cpu.ram[cpu.registers:get_bc()] = value
    elseif r == 1 then cpu.ram[cpu.registers:get_de()] = value
    elseif r == 3 then cpu.ram[get_hl_dec(cpu)] = value
    elseif r == 2 then cpu.ram[get_hl_inc(cpu)] = value
    end
end

function instructions.init(self)
    
end

return instructions