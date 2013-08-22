dofile("config.lua")
dofile(config.path().."luacms/luacms.lua")

index = table.load("lua_data/luacms_index.txt")

luacms.printheader()
print [[<head><title>Edit page</title></head><body>]]
config.navigation()
print [[<hr><h2>Edit page</h2><br>]]

POST_DATA = io.read("*a")     -- Read stdin
post = {}
err = false

if not (POST_DATA == "") and not (POST_DATA == nil) then             -- any data at all?
post = split(POST_DATA, "&")                                        -- Split POST_DATA values
for k, v in ipairs(post) do                                         -- Organize table keys by the POSTDATA: 
assemble_value(v, post)                                            -- [1] = "name=foo" turns into ["name"] = "foo".
post[k] = nil                                                      -- Delete former table keys.
end
else err=true 
end

print ([[
<form method="POST">
Page title:<input type=text name=title maxlength=48 size=48><br>
Tags (separate with ;):<input type=text name=tags size=64>
<br>
<textarea name="content" rows="30" cols="50"></textarea>
<br>
<input type=hidden name=date value="]] .. os.time() .. [[">
<input type=submit name=submit value="Submit">
</p>
</form>
<br>
br>
]])