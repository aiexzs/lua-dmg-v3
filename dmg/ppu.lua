local ppu = {}

local bor, band, bxor, lshift, rshift, tohex = bit.bor, bit.band, bit.bxor, bit.lshift, bit.rshift, bit.tohex

function ppu.init(self, system)
    self.ram = system.ram
    self.line = 0
    self.screen = {}        --160x144 array of pixels, 2bpp grayscale
    self.bgfifo = {}        --8 bit pixel buffer (first in, first out)
    self.scy = 0            --y-axis scrolling
    self.scx = 0            --x-axis scrolling
    self.background = {}    --256x256 array of pixels to store 8x8 background tile data that the viewport will scroll over
    self.backgroundmap = {} --32x32 tilemap array to map the background to

    --initialize stuff

    for x = 1, 160 do
        self.screen[x] = {}
        for y = 1, 144 do
            self.screen[x][y] = 0 --0,1,2,3 for the background shades (0b00, 0b01, 0b10, 0b11)
        end
    end

    for x = 1, 256 do
        self.background[x] = {}
        for y = 1, 256 do
            self.background[x][y] = 0 --0,1,2,3 for the background shades (0b00, 0b01, 0b10, 0b11) (same as screen)
        end
    end

    for x = 1, 32 do
        self.backgroundmap[x] = {}
        for y = 1, 32 do
            self.backgroundmap[x][y] = 0 --same 2bpp format again
        end
    end

    for i = 1, 8 do
        self.bgfifo[i] = 0 --same 2bpp format again
    end

    return self
end

function ppu.decodeTile8000(self, id)
    --[[
        One pixel is 2 bits
        Each tile is 16 bytes, two bytes is one row to make an 8x8 tile
        Union byte pair (ie 0x8010 and 0x8011) to make a 2 bit value,
        can be 0b00, 0b01, 0b10, 0b11 to store palette value
    ]]

    --print("TILE BEGIN") -- for debug purposes
    
    local tileAddr = 0x8000+(id*16)
    
    local tileData = {}
    for row = 1, 8 do
        local tileByte1 = self.ram[tileAddr+((row-1)*2)]
        local tileByte2 = self.ram[tileAddr+1+((row-1)*2)]

        local currentrow = {}
        for i = 1, 8 do

            local b1 = rshift(band(tileByte1, 2^((8-i))), (8-i))
            local b2 = rshift(band(tileByte2, 2^((8-i))), (8-i))
            
            local pixel = bor(lshift(b1, 1), b2)
            currentrow[i] = pixel

            --print(currentrow[i].." ("..bit.tohex(tileByte1, 2).." & "..bit.tohex(tileByte2, 2)..")")
        end
        tileData[row] = currentrow
        --print("@ "..bit.tohex(tileByte1, 4).." and "..bit.tohex(tileByte2, 4))
    end
    
    --print("TILE END")

    return tileData
end

function ppu.decodeTile8000Row(self, id, row)
    local tileAddr = 0x8000 + (id * 16)

    local tileByte1 = self.ram[tileAddr + ((row - 1) * 2)]
    local tileByte2 = self.ram[tileAddr + 1 + ((row - 1) * 2)]
    local currentrow = {}
    for i = 1, 8 do
        local b1 = rshift(band(tileByte1, 2 ^ ((8 - i))), (8 - i))
        local b2 = rshift(band(tileByte2, 2 ^ ((8 - i))), (8 - i - 1))

        local pixel = bor(b2, b1)
        currentrow[i] = pixel
        --print(currentrow[i].." ("..bit.tohex(tileByte1, 2).." & "..bit.tohex(tileByte2, 2)..")")
    end

    return currentrow
end

function ppu.getBackgroundTile(self, map, index)
    local maploc = 0x9800 --+(0x400*(map-1)) --two maps, 0x9800-0x9bff and 0x9c00-9fff 32x32 bytes each
    local offset = maploc + index
    local tileid = self.ram[offset]
    return tileid
end

function ppu.renderBackground(self, map)
    local bg = {}

    for x = 1, 32 do
        for y = 1, 32 do
            local id = map[x][y]
            local tile = self:decodeTile8000(id)
            for i = 1, 8 do
                local xpos = i + (8 * (y - 1))
                bg[xpos] = bg[xpos] or {}
                for j = 1, 8 do
                    local ypos = j + (8 * (x - 1))
                    bg[xpos][ypos] = tile[j][i]
                end
            end
        end
    end

    return bg
end

function ppu.renderTileToBackground(self, id, x, y)
    local tile = self:decodeTile8000(id)
    for i = 1, 8 do
        local xpos = i + (8 * (y - 1))
        for j = 1, 8 do
            local ypos = j + (8 * (x - 1))
            self.background[xpos][ypos] = tile[j][i]
        end
    end
end

function ppu.scanline(self, bg) --background only, for now anyway
    local wx = 0 + self.scx                --todo: set up scx reg
    local wy = self.line + self.scy

    for i = 1, 20 do
        for f = 1, 8 do
            local screenx = f + (8 * (i - 1)) + wx --???
            self.screen[screenx%160+1][self.line] = bg[screenx%255+1][wy]
        end
    end
end

function ppu.tick(self)
    if self.line <= 144 then
        --get background map
        for x = 1, 20 do
            local y = math.fmod(math.floor((self.line+self.scy)/8), 18)+1
            local tile = self:getBackgroundTile(1, y + (32 * (x - 1)))
            if self.backgroundmap[x][y] ~= tile then
                self.backgroundmap[x][y] = tile
                self:renderTileToBackground(tile, x, y)
            end
        end

        self:scanline(self.background)

        self.line = self.line + 1
    elseif self.line == 154 then
        self.line = 0
    else
        self.line = self.line + 1
    end

    self.scy = self.ram[0xff42]
    self.scx = self.ram[0xff43]
    self.ram[0xff44] = self.line
end

return ppu