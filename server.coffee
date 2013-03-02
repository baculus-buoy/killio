restify = require 'restify'
server = restify.createServer()

exec = require('child_process').exec

server.use restify.bodyParser()
server.use restify.fullResponse() # set CORS, eTag, other common headers

server.get '/text', (req, res, next) ->
  console.log "we hit text"
  ids = []
  tmsis = exec "echo tmsis | sudo ./OpenBTSCLI | grep -v TMSI | awk '{print $2}' | grep -v '^$'", (error, stdout, stderr) ->
    for id in stdout.split('\n')
      sendtext = exec "echo sendtext #{id} god #{req.params.message} | sudo ./OpenBTSCLI", (error, stdout, stderr) ->
        res.send "#{req.params.message} sent to #{ids.length} believers"

server.get /\/*$/, restify.serveStatic directory: './public', default: 'index.html'

server.listen (process.env.PORT or 8080), ->
  console.info "[%s] #{server.name} listening at #{server.url}", process.pid