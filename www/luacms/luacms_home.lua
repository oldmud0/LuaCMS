-- LuaCMS page stack/homepage

dofile("config.lua")
dofile(config.path().."luacms/luacms.lua")

index = table.load("lua_data/luacms_index.txt")

luacms.printheader()
print [[<head><title>Home</title></head><body>]]
config.navigation()

for k,v in ipairs(index) do 
	print(k)
	luacms.loadpage(k)
end


config.footer()
print [[</body></html>]]
