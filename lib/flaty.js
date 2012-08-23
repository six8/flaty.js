
/*
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
*/


(function() {
  var ARRAY, INDEX, OBJECT, PROPERTY, SCALAR, exports, fatten, flatten, tokenize,
    __hasProp = {}.hasOwnProperty;

  flatten = function(obj) {
    var data, flatten_val;
    data = {};
    flatten_val = function(path, value) {
      var array_key, i, k, key, v, val, _i, _len, _results;
      if (Array.isArray(value)) {
        array_key = path[path.length - 1];
        for (i = _i = 0, _len = value.length; _i < _len; i = ++_i) {
          val = value[i];
          path[path.length - 1] = array_key + '@' + i;
          flatten_val(path, val);
        }
        return path[path.length - 1] = array_key;
      } else if (typeof value === 'object') {
        _results = [];
        for (k in value) {
          if (!__hasProp.call(value, k)) continue;
          v = value[k];
          path.push(k);
          flatten_val(path, v);
          _results.push(path.pop());
        }
        return _results;
      } else {
        key = path.join('.');
        return data[key] = value;
      }
    };
    flatten_val([], obj);
    return data;
  };

  ARRAY = 'A';

  INDEX = 'I';

  PROPERTY = 'P';

  OBJECT = 'O';

  SCALAR = 'S';

  tokenize = function(str) {
    var buf, char, tokens, type, _i, _len, _ref;
    tokens = [];
    type = function(key, contains) {
      if (tokens.length && tokens[tokens.length - 1][2] === ARRAY) {
        if (key === '') {
          return [INDEX, null, contains];
        } else {
          return [INDEX, parseInt(key, 10), contains];
        }
      } else {
        if (key === '') {
          throw 'Object property missing key.';
        } else {
          return [PROPERTY, key, contains];
        }
      }
    };
    buf = '';
    _ref = str.split('');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      char = _ref[_i];
      if (char === '.') {
        tokens.push(type(buf, OBJECT));
        buf = '';
      } else if (char === '@') {
        tokens.push(type(buf, ARRAY));
        buf = '';
      } else {
        buf += char;
      }
    }
    tokens.push(type(buf, SCALAR));
    return tokens;
  };

  fatten = function(obj) {
    /*jshint expr:true
    */

    var contains, data, input, key, keytype, kstr, store, tokens, value, _i, _j, _len, _len1, _ref, _ref1;
    if (!Array.isArray(obj)) {
      input = [];
      for (kstr in obj) {
        if (!__hasProp.call(obj, kstr)) continue;
        value = obj[kstr];
        input.push([kstr, value]);
      }
    } else {
      input = obj;
    }
    data = {};
    for (_i = 0, _len = input.length; _i < _len; _i++) {
      _ref = input[_i], kstr = _ref[0], value = _ref[1];
      tokens = tokenize(kstr);
      store = data;
      for (_j = 0, _len1 = tokens.length; _j < _len1; _j++) {
        _ref1 = tokens[_j], keytype = _ref1[0], key = _ref1[1], contains = _ref1[2];
        if (contains === SCALAR) {
          if (keytype === INDEX && key === null) {
            store.push(value);
          } else {
            store[key] = value;
          }
        } else if (contains === ARRAY) {
          if (keytype === INDEX && key === null) {
            store.push([]);
            store = store[store.length - 1];
          } else {
            store[key] || (store[key] = []);
            store = store[key];
          }
        } else if (contains === OBJECT) {
          if (keytype === INDEX && key === null) {
            store.push({});
            store = store[store.length - 1];
          } else {
            store[key] || (store[key] = {});
            store = store[key];
          }
        }
      }
    }
    return data;
  };

  /*jshint eqnull:true
  */


  exports = exports != null ? exports : this;

  exports.flaty = {
    flatten: flatten,
    fatten: fatten
  };

}).call(this);
