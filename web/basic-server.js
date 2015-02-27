// Generated by CoffeeScript 1.9.0
var handler, httpLib, initialize, ip, port, server;

httpLib = require("http");

handler = require("./request-handler");

initialize = require("./initialize.js");

initialize();

server = httpLib.createServer();

server.on('request', handler.handleRequest);

port = 8080;

ip = "127.0.0.1";

server.listen(port, ip);

console.log("Listening on http://" + ip + ":" + port);
