httpLib = require "http"
handler = require "./request-handler"
# Import one time folder and file creating func.
initialize = require "./initialize.js"

# Creates archives folder.
initialize()

# Creating Emitter.
server = httpLib.createServer()
# Creating event listner for client.
server.on 'request', handler.handleRequest
# Let the server listen at specified port and ip address
port = 8080
ip = "127.0.0.1"
server.listen port, ip

console.log "Listening on http://#{ip}:#{port}"
