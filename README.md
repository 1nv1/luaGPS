#luaGPS

Module for decoding NMEA sentences of GPS devices with Lua. Also works with
LuaJIT.
The "decode" method allows extract information from NMEA sentences (line
is a group of them) and returns a table with relevant information.
Based on Julien Vermillard work: [lua-nmea](https://github.com/jvermillard/lua-nmea)

## Example of use

```lua

local GPS = require "gps_nmea"

local line = "$GPGGA,092751.000,5321.6802,N,00630.3371,W,1,8,1.03,61.7,M,55.3,M,,*75,$GPGSA,A,3,10,07,05,02,29,04,08,13,,,,,1.72,1.03,1.38*0A, $GPGSV,3,1,11,10,63,137,17,07,61,098,15,05,59,290,20,08,54,157,30*70, $GPRMC,092751.000,A,5321.6802,N,00630.3371,W,0.06,31.66,280511,,,A*45"

local t = GPS.Decode(line)
print(t)
for k,v in pairs(t) do
  print(k, v)
end

```
