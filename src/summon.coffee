path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'

CWD = process.cwd()

argv = require('optimist')
  # debug
  .boolean('debug')
  .default('debug', false)
  .argv

fromRootDir = (path, args...) ->
  path.join CWD, args...

generatorDir = (target) ->
  path.join CWD, '.generators', target

createReadableArgs = (argv) ->
  args = {}
  for k, v of argv when k[0] isnt '$'
    if v.length
      for i, index in v[0..]
        args['$'+(index)] = i
    else # if typeof v is 'string'
      args[k] = v

  args

presetGenratorGenerator =
  defaultGenerator: '''
  module.exports = (g, {$1}) ->
    g.gen "{{$1}}.json.hbs", "app/{{$1}}.json"
  '''

  dummyJson: '''
  {"name": "{{$1}}"}
  '''

  generator: '''
  module.exports = (g, {$1}) ->
    g.gen 'default-generator.coffee.hbs', ".generators/#{$1}/generator.coffee"
    g.gen 'dummy.json.hbs', ".generators/#{$1}/#{$1}.json.hbs"
  '''

module.exports = main = (argv) ->
  {init, debug, _, create} = argv
  args = createReadableArgs(argv)

  command = _[0]

  switch command
    when 'init'
      console.log ' > init .generators'
      try fs.mkdirSync path.join CWD, '.generators'
      try fs.mkdirSync path.join CWD, '.generators', 'generator'

      fs.writeFileSync (path.join CWD, '.generators', 'generator', 'generator.coffee')
        , presetGenratorGenerator.generator

      fs.writeFileSync (path.join CWD, '.generators', 'generator', 'default-generator.coffee.hbs')
        , presetGenratorGenerator.defaultGenerator
      fs.writeFileSync (path.join CWD, '.generators', 'generator', 'dummy.json.hbs')
        , presetGenratorGenerator.dummyJson

    # when 'generate'
    else
      target = _[0]
      genRootDir = generatorDir(target)
      console.log " > generate #{target}"

      g = {}
      g.render = (template, option) ->
        hbs = require 'handlebars'
        hbs.compile(template)(option)

      g.gen = (from, to) ->
        template = fs.readFileSync(path.join genRootDir, from).toString()
        expanded = g.render template, args
        dest = (path.join CWD, to)
        destDir = path.dirname dest
        mkdirp destDir, ->
          fs.writeFileSync dest, expanded
          console.log 'generate ', dest

      generator = require path.join genRootDir, 'generator'
      generator(g, args)

# main(argv)