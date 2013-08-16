
-- NOTE: This file was originally created by Nick Gammon at http://www.gammon.com.au/forum/?id=6498&reply=2#reply2
-- It should be replaced with more original functions later on.

--[[
Copyright © 2006 Nick Gammon.

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.    

The software is provided "as is", without warranty of any kind, express or 
implied, including but not limited to the warranties of merchantability, 
fitness for a particular purpose and noninfringement. In no event shall the 
authors or copyright holders be liable for any claim, damages or other 
liability, whether in an action of contract, tort or otherwise, arising from, 
out of or in connection with the software or the use or other dealings in the 
software. 
--]]


-- Lua utilities for CGI web use

-- split a string with delimiters into a table (reverse of table.concat)


function split (s, delim)

  assert (type (delim) == "string" and string.len (delim) > 0,
          "bad delimiter")

  local start = 1
  local t = {}  -- results table

  -- find each instance of a string followed by the delimiter

  while true do
    local pos = string.find (s, delim, start, true) -- plain find

    if not pos then
      break
    end

    table.insert (t, string.sub (s, start, pos - 1))
    start = pos + string.len (delim)
  end -- while

  -- insert final one (after last delimiter)

  table.insert (t, string.sub (s, start))

  return t
 
end -- function split

-- trim leading and trailing spaces from a string
function trim (s)
  return (string.gsub (s, "^%s*(.-)%s*$", "%1"))
end -- trim

mysql_replacements = { 
   ["\0"] = "\\0",
   ["\n"] = "\\n",
   ["\r"] = "\\r",
   ["\'"] = "\\\'",
   ["\""] = "\\\"",
   ["\026"] = "\\Z",
   ["\b"] = "\\b",
   ["\t"] = "\\t",
   }

-- Fix SQL text by converting various characters to the format MySQL 
--  will recognise in its string processor
--
-- Note that not all the escapes are necessary for internal SQL use, 
-- however if data is being dumped to disk (eg. as SQL statements) 
-- then it is handy for have things like \n and \r made more readable
--   See: http://dev.mysql.com/doc/refman/5.1/en/string-syntax.html

function fixsql (s)

  return (string.gsub (tostring (s), "[%z\n\r\'\"\026\b\t]", 
    function (str)
      return mysql_replacements [str] or str
    end ))

end -- fixsql

html_replacements = { 
   ["<"] = "&lt;",
   [">"] = "&gt;",
   ["&"] = "&amp;",
   }

-- fix text so that < > and & are escaped
function fixhtml (s)

return (string.gsub (tostring (s), "[<>&]", function (str)
  return html_replacements [str] or str
  end ))

end -- fixhtml

-- convert + to space
-- convert %xx where xx is hex characters, to the equivalent byte
function urldecode (s)
  return (string.gsub (string.gsub (s, "+", " "), 
          "%%(%x%x)", 
         function (str)
          return string.char (tonumber (str, 16))
         end ))
end -- function urldecode

-- process a single key=value pair from a GET line (or cookie, etc.)
function assemble_value (s, t)
  assert (type (t) == "table")
  local _, _, key, value = string.find (s, "(.-)=(.+)")

  if key then
    t [trim (urldecode (key))] = trim (urldecode (value))
  end -- if we had key=value

end -- assemble_value

-- output a Lua table as an HTML table
function show_table (t)
  local k, v
  assert (type (t) == "table")
  print "<table border=1 cellpadding=3>"
  for k, v in pairs (t) do
    print "<tr>"
    print ("<th>" .. fixhtml (k) .. "</th>" .. 
           "<td>" .. fixhtml (v) .. "</td>")
    print "</tr>"
  end -- for
  print "</table>"
end -- show_table


--
-- Extended functions. These are not made by Nick Gammon, but they are placed here anyway for convenience.
--
function table.reverse (t)
    local newTable = {}
 
    for i,v in ipairs ( t ) do
        newTable[#t-i] = v
    end
 
    return newTable
end