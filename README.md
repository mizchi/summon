# Summon

Write your generator by handlebars

```
npm install mizchi/summon -g
```

## How to use

```
$ summon init
 > init .generators
$ summon generator foo
 > generate generator
generate  /Users/mizchi/proj/summon/.generators/foo/generator.coffee
generate  /Users/mizchi/proj/summon/.generators/foo/foo.json.hbs
$ summon foo
 > generate foo
generate  /Users/mizchi/proj/summon/app/foo.json
```

## Add you generator

```
$ summon init
$ tree .generators/
.generators/
└── generator
    ├── default-generator.coffee.hbs
    ├── dummy.json.hbs
    └── generator.coffee
```

Write your generator.coffee to `.generators/your-task/generator.coffee`

```coffee
module.exports = (g, {$1}) ->
  g.gen 'default-generator.coffee.hbs', ".generators/#{$1}/generator.coffee"
  g.gen 'dummy.json.hbs', ".generators/#{$1}/#{$1}.json.hbs"
```

For example, dummy.json.hbs

```coffee
{"name": "{{$1}}"}
```

Default `generator` is generator's generator.


arguments properties

```
$ summon foo arg1 arg2 --x 3 --y 4 #=> {$0: 'foo', $1: 'arg1', $2: 'arg2', x: '3', y: '4'}
```


## TODO

- Add example
- JavaScript
- Revert
- Custom Helper