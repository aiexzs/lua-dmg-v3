local helpers = {}

local bor, bnot, band, bxor, lshift, rshift, tohex = bit.bor, bit.bnot, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

function helpers.msb(v)
    return rshift(v, 8)
end

function helpers.lsb(v)
    return band(0xff)
end

function helpers.check_bit(v, n)
    return bit.band(v, (bit.lshift(1, n))) == 1
end

function helpers.unsigned_16(lsb, msb)
    return bor(helpers.msb(msb), lsb)
end

return helpers