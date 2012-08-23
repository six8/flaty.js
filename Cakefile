require 'flour'

task 'lint', 'Check javascript syntax', ->
  lint 'lib/flaty.js'

task 'build:coffee', 'Build coffeescripts', ->
  compile 'src/flaty.coffee', 'lib/flaty.js', ->
    invoke 'lint'

task 'minify', 'Minify JS', ->
  minify 'lib/flaty.js', 'flaty.min.js'

task 'build', 'Build flaty', ->
  invoke 'build:coffee'  
  invoke 'minify'

