dofile("config.lua")
dofile(config.path().."luacms/cgiutils.lua")
dofile(config.path().."luacms/table2file.lua")

-- LuaCMS: a slimmer solution to making websites
-- 
-- PAGE FORMAT: All pages must have an id (auto assigned), title, content, tags (may leave blank as "", split with ;), and a date.
-- The purpose of the index is to facilitate searching and organization. The index only saves the id, title, tags, and date.
-- 
-- Copyright © oldmud0
-- This file is currently unlicensed. Do not distribute without express permission.


luacms = {}



function luacms.version() return "PROTOTYPE" end


function luacms.printheader()
	print [[
Content-Type: text/html

<!DOCTYPE HTML>
<html>]]
end


-- Takes some tags and organizes them so that they are suitable for printing.
function luacms.processtags(tags)
  assert(tags,"(could not process tags)")

  local tags_t = split(tags,";")

  for k,v in ipairs(tags_t) do
    if k == #tags_t then print (v)
    else print (v..", ")
    end
  end
end


-- Adds a page to the CMS and saves it to a file.
function luacms.addpage(page_title,page_content,page_tags)
  assert(page_title,"Could not add page: page_title not identified")
  assert(page_content,"Could not add page: page_content not identified")
  assert(page_tags,"Could not add page: page_tags not identified")

  local index = table.load("lua_data/index.txt")
  local goodid = #index+1

  local page = {["id"]=goodid,["title"]=page_title,["content"]=page_content,["tags"]=page_tags,["date"]=os.time()}

  index[goodid] = {["id"]=page.id,["title"]=page.title,["tags"]=page.tags,["date"]=page.date}

  table.save(index,"lua_data/index.txt")
  table.save(page,"lua_data/page_"..page.id..".txt")
end


-- Updates an existing page.
function luacms.updatepage(page_id,page_title,page_content,page_tags)
  assert(page_id,"Could not update page: page_id not identified")
  assert(page_title,"Could not update page: page_title not identified")
  assert(page_content,"Could not update page: page_content not identified")
  assert(page_tags,"Could not update page: page_tags not identified")

  local index = table.load("lua_data/index.txt")

  local page = {["id"]=page_id,["title"]=page_title,["content"]=page_content,["tags"]=page_tags,["date"]=os.time()}

  index[page_id] = {["id"]=page_id,["title"]=page.title,["tags"]=page.tags,["date"]=page.date}

  table.save(index,"lua_data/index.txt")
  table.save(page,"lua_data/page_"..page.id..".txt")
end


-- Loads a page from file and prints it out.
function luacms.loadpage(page_id)
  assert(page_id,"Could not load page: page_id not provided")

  local page = table.load("lua_data/page_"..page_id..".txt")
  assert(page,"Could not load page: File not found")
  
  print ([[<h2>]]..page.title..[[</h2>
    <br><i>Last updated ]]..os.date("%c",page.date)..[[</i><br>
    Tags: ]]..luacms.processtags(page.tags)..[[<br>
    <p>]]..page.content..[[</p><br><hr>]])
end


-- Show the comments of any given page.
function luacms.showcomments(page_id)
  assert(page_id,"Could not show comments: page_id not identified")
  print [[<h1>Comments</h1>]]
  
  comments = table.load("lua_data/comments_"..page_id..".txt")
  --for k,v in pairs(comments) do for i,j in pairs(v) do print(i,j) end end
  
  if comments == nil then
    print [[No comments posted. Be the first to post!<br>]]
    comments = {}
   else 
    for k,v in ipairs(comments) do print ([[
    <p><b>]].. v.name ..[[</b> posted at ]].. os.date("%c",v["date"]) ..[[: <br><p>]].. v.content ..[[</p></p><br>]]) 
    end
  end
  ----------------
  print ([[
  <hr>
  <form method="POST">
  <p><h1>Post comment</h1>
  <br>
  Name:<input type=text name=name maxlength=32>
  <br>
  <textarea name="content" rows="10" cols="30"></textarea>
  <br>
  <input type=hidden name=date value="]] .. os.time() .. [[">
  <input type=submit name=submit value="Post comment">
  </p>
  </form>
  <br>
  <br>
  ]])
  ----------------
  
  POST_DATA = io.read("*a")     -- Read stdin
  --print(POST_DATA)
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
  
  if not err then
   if type(post.name) == "nil" and type(post.content) == "nil" and err==false then print([[<p style="color:ee1200">Error: Please type in a valid comment.</p><br>]])
	  err=true end
   if type(post.name) == "nil" and err==false then print([[<p style="color:ee1200">Error: You did not type anything in the name field.</p><br>]]) 
	  err=true end
   if type(post.content) == "nil" and err==false then print([[<p style="color:ee1200">Error: Please type in a comment at least of 10 characters in length.</p><br>]])
 	  err=true
   elseif err==false and post.content:len() < 10 then print([[<p style="color:ee1200">Error: Please type in a comment at least of 10 characters in length.</p><br>]]) 
	  err=true
   elseif err==false and post.content:len() > 512 then print([[<p style="color:ee1200">Error: Your comment has more than 512 characters. Please rephrase your comment or split it into multiple ones.</p><br>]]) 
	  err=true end
  end
  
  if not err then
   comments[#comments+1] = post
   
   table.save(comments,"lua_data/comments_"..page_id..".txt")
   print ([[<p style="color:ee1200">Thank you. Your post will be shown after you refresh the page.</p><br>]])
  end
  
  -- for testing purposes only
  --
  -- if post.name == "admin" then
  --  print ("<hr><br><p>Request method = ".. os.getenv("REQUEST_METHOD").. "</p>")
  --  print "<h1>POST data</h1>\n"
  --  show_table (post)
  -- end
end


-- FIRST TIME USE: Creates an index for searching as well as the main page. Sets up config.
function luacms.setup()
  local config_test,err = table.load("lua_data/luacms_config.txt")
  if type(config_test) == "nil" then
    local index = {}
    local config = {}
    config["setup"] = "done"
    local page = {["id"]=1, ["title"]="Main Page",["content"]=[[Welcome to LuaCMS! LuaCMS has been installed properly.<br>
    This is the default main page. Please edit it after you have familiarized yourself with the control panel.<br>
    Visitors: the admin has not created any content on this page yet. Please contact the webmaster if you continue to see this page.]],
    ["tags"]="",["date"]=os.time()}

    index[1] = {["id"]=1,["title"]=page.title,["tags"]=page.tags,["date"]=page.date}
    table.save(index,"lua_data/luacms_index.txt")
    table.save(page,"lua_data/page_1.txt")
    table.save(config,"lua_data/luacms_config.txt")
    return false
  else
    return true, "Already set up"
  end
end