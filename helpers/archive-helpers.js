// Generated by CoffeeScript 1.9.0
var fsLib, httpReq, path, _;

fsLib = require('fs');

path = require('path');

_ = require('underscore');

httpReq = require('http-request');


/*
You will need to reuse the same paths many times over in the course of this sprint.
Consider using the `paths` object below to store frequently used file paths. This way,
if you move any files, you'll only need to change your code in one place! Feel free to
customize it in any way you wish.
 */

exports.paths = {
  'siteAssets': path.join(__dirname, '../web/public'),
  'archivedSites': path.join(__dirname, '../archives/sites'),
  'list': path.join(__dirname, '../archives/sites.txt')
};

exports.initialize = function(pathsObj) {
  return _.each(pathsObj, function(path, type) {
    return exports.paths[type] = path;
  });
};


/*
 Archive helpers are like database management system. It stores it's data in plain text.
 This has a convenience in server side since everything that is recieved from the server side
 is in text format.
 */

exports.readListOfUrls = function(cb) {
  return fsLib.readFile(exports.paths.list, function(error, content) {
    var contentInArray;
    content = content.toString();
    contentInArray = content.split('\n');

    /*
     returning value here won't do any good. Where does the callback returning to? fsLib.readFile called it. what does
     do with returned value? Does it catch it? Even if it does catch it, initially it will be undfined. Hence
    returning fs.readFile(..) won't do any good.
     */
    return typeof cb === "function" ? cb(contentInArray) : void 0;
  });

  /*
   If it was returned here it would be undefined. When using async functions don't return anything.
   Always provide a callback function in which to extract the content out later. Without async nature we could of think
  that we will do something with returned value later, here that later is defined as calling a callback funtion.
  return contentInArray
   */
};

exports.isUrlInList = function(url, cb) {
  return exports.readListOfUrls(function(contentInArray) {
    var bool;
    if (_.indexOf(contentInArray, url) > -1) {
      bool = true;
    } else {
      bool = false;
    }
    return cb(bool);
  });
};

exports.addUrlToList = function(url, cb) {
  var list;
  list = exports.paths.list;
  return fsLib.open(list, 'a', function(error, fd) {
    var line;
    line = url + "\n";
    fsLib.write(fd, line, function(err, written, string) {
      return console.log("Error: " + err + ", Written: " + written + ", String: " + string);
    });
    return fsLib.close(fd, function() {
      return console.log('done');
    });
  });

  /* Below works but there must be a better way. Too low, buffer... really?.
  fsLib.open exports.paths.list, 'a', (error, fd)->
    fileToWrite = "#{url}\n"
    buf = new Buffer fileToWrite
    fsLib.write fd, buf, 0, buf.length, fd.length, (err, written, buffer)->
      console.log(err, written, buffer);
    fsLib.close fd, ->
      console.log 'done'
   */
};

exports.isUrlArchived = function(url, cb) {
  return fsLib.fileExist(exports.paths.list + "/" + url, function(fileExists) {
    if (fileExists) {
      return typeof cb === "function" ? cb(fileExists) : void 0;
    }
  });
};

exports.downloadUrls = function(url, cb) {
  return httpReq.get("http://" + url, exports.paths.archivedSites + "/" + url, function(err, res) {
    return typeof cb === "function" ? cb(res) : void 0;
  });
};


/*
///////////////////////////////////////////////////////////////
////////////// QUESTION//////////////////////////////////////
// What is the type of returned object of the readFile? typeof wholeContent === object but when I .length it I get not undefined.
//It's not array as Array.isArray(wholeContent) is false. What is it? is it JSON? How do I check whether it is a JSON? 
// Is there a way for a caller of callback to catch the value returned by the callback function?
 */
