from fabric.api import task, require, env, local, lcd
from os import path
from clom import clom

@task
def build():
	local(clom.coffee('src', c=True, o='lib'), capture=False)
	local(clom.uglifyjs.with_args('-nc')('lib/flaty.js', o='flaty.min.js'), capture=False)

@task
def test():
	local(clom['jasmine-node']('spec', coffee=True), capture=False)