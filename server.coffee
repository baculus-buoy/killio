restify = require 'restify'
server = restify.createServer()

exec = require('child_process').exec

server.use restify.queryParser()
server.use restify.fullResponse() # set CORS, eTag, other common headers

server.get '/text', (req, res, next) ->
  #exec "echo tmsis | sudo ./OpenBTSCLI | grep -v TMSI | awk '{print $2}' | grep -v '^$'", (error, stdout, stderr) ->
  exec "cat tmsis | grep -v TMSI | awk '{print $2}' | grep -v '^$'", (error, stdout, stderr) ->
    for id in stdout.split('\n')
      if id isnt ''
        sendtext = exec "echo sendtext #{id} 23456 #{req.query.message} | sudo ./OpenBTSCLI", (error, stdout, stderr) ->
          res.send "#{req.query.message} sent to #{ids.length} believers"

server.get /\/*$/, restify.serveStatic directory: './public', default: 'index.html'

server.listen (process.env.PORT or 8080), ->
  console.info "[%s] #{server.name} listening at #{server.url}", process.pid