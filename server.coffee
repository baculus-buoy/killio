# server
restify = require 'restify'
server = restify.createServer()

spawn = require('child_process').spawn;

# cors proxy and body parser
server.use restify.bodyParser()
server.use restify.fullResponse() # set CORS, eTag, other common headers

server.get '/text', (req, res, next) ->
  console.log 'get text'
  tmsis = spawn "tmsis"
  ids = []
  tmsis.stdout.on 'data', (data) -> ids.push data.toString()
  tmsis.stdout.on 'end', (data) ->
    for id in ids
      sendtext = spawn "sendtext #{id} god"
      sendtext.stdin.write req.params.message
      sendtext.stdin.end()
    res.send "'#{req.params.message}' sent to #{ids.length} believers"

server.get /\/*$/, restify.serveStatic directory: './public', default: 'index.html'

server.listen (process.env.PORT or 8080), ->
  console.info "[%s] #{server.name} listening at #{server.url}", process.pid