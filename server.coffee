restify = require 'restify'
server = restify.createServer()

exec = require('child_process').exec

server.use restify.queryParser()
server.use restify.fullResponse() # set CORS, eTag, other common headers

server.get '/numbers', (req, res, next) ->
  console.log command = "echo tmsis | sudo ./OpenBTSCLI | grep -v TMSI | awk '{print $2}' | grep -v '^$' | grep -E \"[0-9]+\""
  exec command, (error, stdout, stderr) ->
    res.send stdout

server.get '/toggle', (req, res, next) ->
  console.log command = ""
  exec command, (error, stdout, stderr) ->
    res.send stdout

server.get '/text', (req, res, next) ->
  console.log req.params.numbers
  console.log command = "echo tmsis | sudo ./OpenBTSCLI | grep -v TMSI | awk '{print $2}' | grep -v '^$' | grep -E \"[0-9]+\""
  exec command, (error, stdout, stderr) ->
    numsent = 0
    for id in stdout.split('\n')
      if id isnt ''
        console.log command = "echo sendsms #{id} 23456 #{req.query.message} | sudo ./OpenBTSCLI"
        exec command, (error, stdout, stderr) ->
          numsent++
    res.send()

server.get /\/*$/, restify.serveStatic directory: './public', default: 'index.html'

server.listen (process.env.PORT or 8080), ->
  console.info "[%s] #{server.name} listening at #{server.url}", process.pid