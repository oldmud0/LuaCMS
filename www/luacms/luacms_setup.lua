dofile("config.lua")
dofile(config.path().."luacms/luacms.lua")

luacms.printheader()

print ([[<h1>LuaCMS First Time Config</h1><br>
LuaCMS running version ]]..luacms.version()..[[<br>
Lua running version ]].._VERSION:sub(5)..[[<br>
<br>
Autoconfiguring... <br>]])

local err, errcode = luacms.setup()
if err or errcode then print ([[<b>ERROR: ]]..errcode..[[</b><br>]]) else print [[Success!<br>]] end