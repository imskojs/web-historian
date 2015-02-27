fsLib = require 'fs' 
path = require 'path'
_ = require 'underscore'
httpReq = require 'http-request'

###
You will need to reuse the same paths many times over in the course of this sprint.
Consider using the `paths` object below to store frequently used file paths. This way,
if you move any files, you'll only need to change your code in one place! Feel free to
customize it in any way you wish.
###


exports.paths = 
  # path.join joins strings and makes it into readable URL
  #Notice how '../' is used with __dirname. it auto concats.
  'siteAssets' : path.join __dirname, '../web/public' 
  'archivedSites' : path.join __dirname, '../archives/sites' 
  'list' : path.join __dirname, '../archives/sites.txt' 

# Used for stubbing paths for jasmine tests, do not modify
exports.initialize = (pathsObj)->
  _.each pathsObj, (path, type)->
    exports.paths[type] = path


###
 Archive helpers are like database management system. It stores it's data in plain text.
 This has a convenience in server side since everything that is recieved from the server side
 is in text format.
###
exports.readListOfUrls = (cb)->
  fsLib.readFile exports.paths.list, (error, content)->
    #typeof content === object. What kind of object? it's got a length!
    content = content.toString()
    contentInArray = content.split '\n'
    ###
     returning value here won't do any good. Where does the callback returning to? fsLib.readFile called it. what does
     do with returned value? Does it catch it? Even if it does catch it, initially it will be undfined. Hence
    returning fs.readFile(..) won't do any good.
    ###
    cb? contentInArray
  ###
   If it was returned here it would be undefined. When using async functions don't return anything.
   Always provide a callback function in which to extract the content out later. Without async nature we could of think
  that we will do something with returned value later, here that later is defined as calling a callback funtion.
  return contentInArray
  ###

exports.isUrlInList = (url, cb)->
  exports.readListOfUrls (contentInArray)->
    if _.indexOf(contentInArray, url) > -1 then bool = true else bool = false
    cb(bool);

exports.addUrlToList = (url, cb)->
  list = exports.paths.list
  fsLib.open list, 'a', (error, fd)->  # 'a' makes the writing appendable
    line = "#{url}\n"
    fsLib.write fd, line, (err, written, string)->
      console.log "Error: #{err}, Written: #{written}, String: #{string}"
    fsLib.close fd, ->
      console.log 'done'
  ### Below works but there must be a better way. Too low, buffer... really?.
  fsLib.open exports.paths.list, 'a', (error, fd)->
    fileToWrite = "#{url}\n"
    buf = new Buffer fileToWrite
    fsLib.write fd, buf, 0, buf.length, fd.length, (err, written, buffer)->
      console.log(err, written, buffer);
    fsLib.close fd, ->
      console.log 'done'
  ###

exports.isUrlArchived = (url, cb)->
  fsLib.fileExist "#{exports.paths.list}/#{url}", (fileExists)->
    if fileExists
      cb?(fileExists)

exports.downloadUrls = (url, cb)->
  httpReq.get "http://#{url}", "#{exports.paths.archivedSites}/#{url}", (err, res)->
    # below code attempts to change the encoding by altering charset of the metadata.
    cb?(res)










###
///////////////////////////////////////////////////////////////
////////////// QUESTION//////////////////////////////////////
// What is the type of returned object of the readFile? typeof wholeContent === object but when I .length it I get not undefined.
//It's not array as Array.isArray(wholeContent) is false. What is it? is it JSON? How do I check whether it is a JSON? 
// Is there a way for a caller of callback to catch the value returned by the callback function?
###