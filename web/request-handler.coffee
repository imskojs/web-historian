pathLib = require 'path'
archive = require '../helpers/archive-helpers.js'
# require more modules/folders here!
urlLib = require 'url'
httpHelper = require './http-helpers.js'

exports.handleRequest = (req, res)->
  # GET method
  if req.method is "GET"
    url = req.url  # get requested url :string
    parts = urlLib.parse url   # break url into parts (convenient for url requests with query string) :string
    pathname = parts.pathname  # subset pathname from parts
    if pathname is '/' then pathname = pathLib.join pathname, 'index.html'  # / ==> /index.html
    httpHelper.serveAssets res, pathname  # sending response
  # POST method
  if req.method is "POST"
    data = ""
    req.on 'data', (bin)->  # POST with data attribute is really a eventData: dataContent
      data += bin
    req.on 'end', (url)->  # data is url
      archive.isUrlInList url, (inTheList)->
        if inTheList 
          archive.isUrlInArchive url, (inTheArchive)->
            if inTheArchive
              httpHelper.sendRedirect res, url
            else # is in the list but not in archive
              httpHelper.sendRedirect res, '/loading.html'
              ### 
              TODO: Fetch and add to archive.
              ###
              archive.downloadUrls url
        else #not in the list
          archive.addUrlToList url, ->
            httpHelper.sendRedirect res, '/loading.html'
          archive.downloadUrls url











      # archive.isUrlInList pathname, (bool)->
      #   if bool
      #     httpHelper.sendRedirect res, '/loading.html', stat
      #   else
      #     archive.addUrlToList pathname, ->



      # Do something with data.




# when the client asks for /index.html we have to make sure that we serve __dirname + location of index relative to this file.
#In this case we have to got to public/index.html if this file was in say helpers directoryp we would have to write 
#__dirname + ../web/public/index.html  __dirname is the root this root however could be www.whatever.com/sub1/ depending on
#how you structure your site. so we use __dirname to not worry about the case where we have to change the structure of the website.
# At the end of __dirname + relativePathFromTheFile we get the absolute path




  







###
//////////////////////////////////////////////////////
/////////////////  QQQQQQQQQQQQQQQQ //////////////////
//////////////////////////////////////////////////////
// When client first connects to the server it sends GET? what does it ask for in the GET? i.e. data part.
###


# Fail if when?
#