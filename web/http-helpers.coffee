pathLib = require 'path'
fsLib = require 'fs'
urlLib = require 'url'
# Working with archive folder and files. Read Write to and from disk
archive = require '../helpers/archive-helpers' 
# Resolving Cor
exports.headers = headers = 
  "access-control-allow-origin": "*"
  "access-control-allow-methods": "GET, POST, PUT, DELETE, OPTIONS"
  "access-control-allow-headers": "content-type, accept"
  "access-control-max-age": 10 # Seconds.
  'Content-Type': "text/html",
  "encoding": "utf-8"


# Helper of serveAssets
exports.sendResponse = (res, content)->
  res.writeHead 200, headers 
  res.write content
  res.end()
# Function to be ran to serve contents.
exports.serveAssets = (res, asset, callback)->
  ###
  Check the public folder for requested assets.
  If requested asset does not exist , check the archive folder
    If requested asset does not exist in archive folder
  ###
  siteAssets = "#{archive.paths.siteAssets}#{asset}"
  archivedSites = "#{archive.paths.archivedSites}#{asset}"
  if fsLib.existsSync siteAssets
    fsLib.readFile siteAssets,
      "encoding": "utf-8"
    , (err, content)->
        exports.sendResponse(res, content)
  else if fsLib.existsSync archivedSites
    fsLib.readFile archivedSites,
      "encoding": "utf-8"
    , (err, content)->
        exports.sendResponse(res, content)
  else
    res.writeHead 404
    res.end 'page not found'
# Redirect
exports.sendRedirect = (res, loc)->
  res.writeHead 302, 
    "Location": loc
  res.end()



# When user submits a form POST request is sent to the server and server would respond with the html directly. However if the user
#refreshes the page while the POST request is being processed it will resubmit the POST request. Rather than doing this when the 
#POST request is sent we should redirect to the different page and request a GET request from there to retrieve the result of the
#POST request.

# sendRedirect functions loc is the url of the GET request sent by the client. It is not the relative path of the location of the file
#It is sending GET request at new location specified by the 'loc'

