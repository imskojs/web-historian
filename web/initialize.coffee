fs = require 'fs'

# Sync uses Syncronous file reading and writing.
module.exports = ()->
  if not fs.existsSync "./archives"
    fs.mkdirSync "./archives"
  if not fs.existsSync "./archives/sites.txt"
    file = fs.openSync "./archives/sites.txt", "w"
    fs.closeSync file 
  if not fs.existsSync "./archives/sites"
    fs.mkdirSync "./archives/sites"
