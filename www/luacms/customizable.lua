-- Customizable
-- The webmaster/admin is free to change this file without affecting LuaCMS.
-- Here, the admin can edit the navigation/footer of webpages and add additional functions if necessary.

custom = {}

--Do not delete!
function custom.navigation()
  print ([[<h1>LuaCMS</h1><br>]])
end

function custom.footer()
  print ([[<hr>
  LuaCMS<br>
  Generated in ]]..os.clock()..[[ ms]])
end