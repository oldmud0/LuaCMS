-- LuaCMS page stack/homepage

dofile("www/luacms/luacms.lua")
dofile("www/luacms/customizable.lua")

index = table.load("lua_data/luacms_index.txt")

luacms.printheader()
print [[<head><title>Home</title></head><body>]]
custom.navigation()

luacms.loadpage("1")


custom.footer()
print [[</body></html>]]
