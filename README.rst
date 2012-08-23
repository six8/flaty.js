=====
Flaty
=====

.. image:: https://secure.travis-ci.org/six8/flaty-javascript.png
    :target: http://travis-ci.org/six8/flaty-javascript
    :alt: Build Status

Flaty is a method for condensing a multi-dimensional JSON like object into a single-dimensional object.

Example::

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

Why would you want to do this?
------------------------------

Often times you need to represent deeply nested objects as flat ones. For example, in HTML forms::

  <form action="POST">
    <input type="text" name="address.street"/>
    <input type="text" name="address.city"/>
    <input type="text" name="address.zip"/>
    <hr/>
    <input type="text" name="contacts@0"/>
    <input type="text" name="contacts@1"/>
    <input type="text" name="contacts@2"/>
  </form>

This also makes it easier to mix AJAX with forms::

  $ = jQuery

  // Load form from AJAX get
  var data = flaty.flatten(json_response);

  // Set form values
  for ( k in data ) {
    $('form input[name="' + k + '"]').val(data[k]);
  }

  // Submit form with AJAX post
  var form_data = {};
  $('input, select, textarea').each(function() {
    var field = $(this);
    form_data[field.attr('name')] = field.val()
  })

  var json_data = flaty.fatten(form_data);

Flaty is also convenient for URL queries::

  var urlParams = function (q) {
      var params = {};
      var e,
          a = /\+/g,
          r = /([^&=]+)=?([^&]*)/g,
          d = function (s) { return decodeURIComponent(s.replace(a, " ")); };

      while (e = r.exec(q))
         params[d(e[1])] = d(e[2]);
      return params;
  };

  var url = 'http://example.com?address.street=123+Road+Drive&address.city=Austin&name.first=Bob&name.last=Smith';

  var params = urlParams(url.split('?')[1]);

  // params will be:
  /*
  {
    'address.street': '123+Road+Drive',
    'address.city': 'Austin',
    'name.first': 'Bob',
    'name.last': 'Smith'
  }
  */

  var data = flaty.fatten(param);

  // data will be:
  /*
  {
    'address': {
      'street': '123+Road+Drive',
      'city': 'Austin'
    },
    'name': {
      'first': 'Bob',
      'last': 'Smith'    
    }
  }
  */

Development and Testing
-----------------------

Install node modules::

  npm install .

Run tests::

  npm test

Building uses `flour <https://github.com/ricardobeat/cake-flour>`_ which requires node.js >=0.8.7::

  cake build



