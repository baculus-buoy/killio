restify = require 'restify'
server = restify.createServer()

exec = require('child_process').exec

server.use restify.queryParser()
server.use restify.fullResponse() # set CORS, eTag, other common headers

server.get '/text', (req, res, next) ->
  console.log command = "echo tmsis | sudo ./OpenBTSCLI | grep -v TMSI || awk '{print $2}' | grep -v '^$' | grep -E \"[0-9]+\""
  exec command, (error, stdout, stderr) ->
    for id in stdout.split('\n')
      if id isnt ''
        console.log "sending to id #{id}"
        console.log command = "echo sendsms #{id} 23456 #{req.query.message} | sudo ./OpenBTSCLI"
        exec command, (error, stdout, stderr) ->

    res.send "#{req.query.message} sent to #{ids.length} believers"

server.get /\/*$/, restify.serveStatic directory: './public', default: 'index.html'

server.listen (process.env.PORT or 8080), ->
  console.info "[%s] #{server.name} listening at #{server.url}", process.pid