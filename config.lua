-- Configuration
-- Here, the admin can edit the navigation/footer of webpages and add additional functions if necessary.

custom = {}
config = {}

-- IMPORANT: Change this to your live web folder. 
-- For example, if your live web is located at WWebserver/www, then put "www/". Usually the root folder is where the web server's executable is.
function config.path() return "www/" end

-- Do not delete!
function config.navigation()
  print ([[<h1>LuaCMS</h1><br>]])
end

function config.footer()
  print ([[<hr>
  LuaCMS<br>
  Generated in ]]..os.clock()..[[ ms]])
end