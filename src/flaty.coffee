###
Flatten or fatten a Flat JSON object.

Example:
  obj =
    name: 'foo'
    val: 'bar'
    key1: 'test'
    ary: ['a', 'b', 'c', {x: 1, y: 3}, [1, 2, 3]]
    obj:
      t: 'a'
      z: 'x'
      nest: [1, 2, 3, 4]
      us:
        texas:
          austin: 'Weird'
          dallas: 'Cowboy'

  console.log(flaty.flatten(obj))

  flat =
    'ary@0': "a"
    'ary@1': "b"
    'ary@2': "c"
    'ary@3.x': 1
    'ary@3.y': 3
    'ary@4@0': 1
    'ary@4@1': 2
    'ary@4@2': 3
    'key1': "test"
    'name': "foo"
    'obj.nest@0': 1
    'obj.nest@1': 2
    'obj.nest@2': 3
    'obj.nest@3': 4
    'obj.t': "a"
    'obj.us.texas.austin': "Weird"
    'obj.us.texas.dallas': "Cowboy"
    'obj.z': "x"
    'val': "bar"

  console.log(flaty.fatten(flat))
###

# Take a nested JSON style object and flatten it into a single dimension object
flatten = (obj) ->
  data = {}
  flatten_val = (path, value) ->
    if Array.isArray(value)
      array_key = path[path.length-1]
      for val, i in value
        path[path.length-1] = array_key + '@' + i
        flatten_val(path, val)
      path[path.length-1] = array_key
    else if typeof value == 'object'
      for own k, v of value
        path.push(k)
        flatten_val(path, v)
        path.pop()
    else
      key = path.join('.')
      data[key] = value

  flatten_val([], obj)
  return data

ARRAY = 'A'
INDEX = 'I'
PROPERTY = 'P'
OBJECT = 'O'
SCALAR = 'S'

# Break apart a Flaty key into its components
tokenize = (str) ->  
  tokens = []
  type = (key, contains) -> 
    if tokens.length and tokens[tokens.length-1][2] == ARRAY
      if key == ''
        # This is an array with an unspecified index
        return [INDEX, null, contains]
      else  
        return [INDEX, parseInt(key), contains]
    else 
      if key == ''
        throw 'Object property missing key.'
      else
        return [PROPERTY, key, contains]

  buf = ''
  for char in str.split('')
    if char == '.'
      tokens.push(type(buf, OBJECT))
      buf = ''    
    else if char == '@'
      tokens.push(type(buf, ARRAY))
      buf = ''
    else
      buf += char

  tokens.push(type(buf, SCALAR))

  return tokens

# Take a single dimension Flaty JSON object and restore it
fatten = (obj) ->  
  if not Array.isArray(obj)
    input = []
    for own kstr, value of obj
      input.push([kstr, value])
  else
    input = obj

  data = {}
  for [kstr, value] in input
    tokens = tokenize(kstr)
    # Walk the object tree
    store = data    
    for [keytype, key, contains] in tokens
      if contains == SCALAR
        if keytype == INDEX and key is null
          store.push(value)
        else
          store[key] = value
      else if contains == ARRAY
        if keytype == INDEX and key is null
          store.push([])
          store = store[store.length-1]
        else
          store[key] or= []
          store = store[key]
      else if contains == OBJECT
        if keytype == INDEX and key is null
          store.push({})
          store = store[store.length-1]
        else      
          store[key] or= {}
          store = store[key]

  return data

exports = exports ? this
exports.flaty =
  flatten: flatten
  fatten: fatten