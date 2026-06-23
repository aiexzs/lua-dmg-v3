local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

local registers = {
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

        self.a = rshift(value, 8)
        self.f = band(value, 0xF0)  -- lower 4 bits must always be 0
    end,

    get_af = function(self)
        return bor(lshift(self.a, 8), self.f)
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

return registers