-- gps_nmea.lua
--
-- Module for decoding NMEA sentences of GPS devices.
--

local _GPS = {}

-- Decode method for NMEA sentences (line is a group of them) and returns a table with the understood values (the most significant).
function _GPS.Decode (line) 
    local function Split_String(str, pat)
       local t = {}  -- NOTE: use {n = 0} in Lua-5.0
       local fpat = "(.-)" .. pat
       local last_end = 1
       local s, e, cap = str:find(fpat, 1)
       while s do
          if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
          end
          last_end = e+1
          s, e, cap = str:find(fpat, last_end)
       end
       if last_end <= #str then
          cap = str:sub(last_end)
          table.insert(t, cap)
       end
       return t
    end
    local i = 1
    local response = {}
    local frame = {}
    local data = {}
    -- First, separate information in frame:
    local frame = Split_String(line,"$GP")
    
    while frame[i] ~= nil do
        data = Split_String (frame[i], ",")
        if data [1] == "GSA" then
            response["mode1"] = tostring(data[2])
            response["mode2"] = tostring(data[3])
        end
        if data [1] == "RMC" then
            response["hour"] = tonumber(string.sub(data[2],1,2))
            response["minute"] = tonumber(string.sub(data[2],3,4))
            response["second"] = tonumber(string.sub(data[2],5,10))
            response["day"] = tonumber(string.sub(data[10],1,2))
            response["month"] = tonumber(string.sub(data[10],3,4))
            response["year"] = tonumber(string.sub(data[10],5))
            response ["status"] = tostring(data[3])
            response ["latitude"] = tonumber (string.sub(data[4],1,2)) + (tonumber(string.sub(data[4],3)) / 60)
            if data[5] == "S" then
                response ["latitude"] = -1 * response ["latitude"] 
            end
            response ["longitude"] = tonumber(string.sub(data[6],1,3)) + (tonumber(string.sub(data[6],4)) / 60)
            if data[7] == "W" then
                response ["longitude"] = -1 * response ["longitude"] 
            end
            response ["speed"] = tonumber(data[8]) * 1.852    -- knots to km/h.
            response ["course"] = tonumber(data[9])         
        end
        i = i + 1
    end
    return response
end

return _GPS
