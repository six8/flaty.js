flaty = (require '../src/flaty').flaty

FAT =
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

FLAT =
  'ary@0': "a"
  'ary@1': "b"
  'ary@2': "c"
  'ary@3.x': 1
  'ary@3.y': 3
  'ary@4@0': 1
  'ary@4@1': 2
  'ary@4@2': 3
  'key1': "test"
  'obj.nest@2': 3  
  'name': "foo"  
  'obj.nest@0': 1
  'obj.nest@1': 2
  'obj.nest@3': 4
  'obj.t': "a"
  'obj.us.texas.austin': "Weird"
  'obj.us.texas.dallas': "Cowboy"
  'obj.z': "x"
  'val': "bar"  

describe 'flatten', ->
  it 'can flatten an object', ->
    expect(flaty.flatten(FAT)).toEqual FLAT


describe 'fatten', ->
  it 'can fatten an object', ->
    expect(flaty.fatten(FLAT)).toEqual FAT

  it 'can fatten an array of key, value pairs', ->
    values = ([k, v] for own k, v of FLAT)
    expect(flaty.fatten(values)).toEqual FAT
 
  it 'can fatten an array without indexes', ->
    expect(flaty.fatten([
      ['ary@', 'a']
      ['ary@', 'b']
      ['ary@', 'c']
      ['ary@', 'd']
      ['ary@@', '1']
      ['ary@@', '2']
    ])).toEqual { ary: [ 'a', 'b', 'c', 'd', [ '1' ], [ '2' ] ] }
