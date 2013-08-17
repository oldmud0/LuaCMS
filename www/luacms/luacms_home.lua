-- LuaCMS page stack/homepage

dofile("config.lua")
dofile(config.path().."luacms/luacms.lua")

index = table.load("lua_data/luacms_index.txt")

luacms.printheader()
print [[<head><title>Home</title></head><body>]]
config.navigation()

luacms.loadpage("1")


config.footer()
print [[</body></html>]]
