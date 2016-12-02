## LuaUnit  
*by Philippe Fremy

[![Build status](https://ci.appveyor.com/api/projects/status/us6uh4e5q597jj54?svg=true&passingText=Windows%20Build%20passing&failingText=Windows%20Build%20failed)](https://ci.appveyor.com/project/bluebird75/luaunit)
[![Build Status](https://travis-ci.org/bluebird75/luaunit.svg?branch=master)](https://travis-ci.org/bluebird75/luaunit)
[![Documentation Status](https://readthedocs.org/projects/luaunit/badge/?version=latest)](https://readthedocs.org/projects/luaunit/?badge=latest)

LuaUnit is a unit-testing framework for Lua. It allows you 
to write test functions and test classes with test methods, combined with 
setup/teardown functionality. A wide range of assertions are supported.

LuaUnit supports several output formats, like JUnit or TAP, for easier integration
into Continuous Integration platforms (Jenkins, Maven, ...). The integrated command-line 
options provide a flexible interface to select tests by name or patterns, control output 
format, set verbosity, ...

LuaUnit works with Lua 5.1, 5.2 and 5.3 . It was tested on Windows XP, Windows Server 2012 R2 (x64) and Ubuntu 14.04 (see 
continuous build results on [Travis-CI](https://travis-ci.org/bluebird75/luaunit) and [AppVeyor](https://ci.appveyor.com/project/bluebird75/luaunit) ) and should work on all platforms supported by Lua.
It has no other dependency than Lua itself. 

LuaUnit is packed into a single-file. To make start using it, just add the file to your project.

LuaUnit is maintained on github:
https://github.com/bluebird75/luaunit

For more information on LuaUnit development, please check: [Developing LuaUnit](http://luaunit.readthedocs.org/en/latest/#developing-luaunit)

It is released under the BSD license.

Documentation is available on
[read-the-docs](http://luaunit.readthedocs.org/en/latest/)

##Install

**github** 

The simplest way to install LuaUnit is to fetch the github version:

    git clone git@github.com:bluebird75/luaunit.git

Then copy it into your project or the Lua libs directory.

On Linux, you can also install it into your Lua directories

    sudo python doit.py install

Edit `install()` for Lua version and installation directory if that
fails. It uses, by default, Linux paths that depend on the version. 

**bower**

You can also install it with bower :

    bower install https://github.com/bluebird75/luaunit.git.

**LuaRocks**

The version on LuaRocks is outdated. Uploading a new version is planned in the future.

##Contributors
* [NiteHawk](https://github.com/n1tehawk)
* [AbigailBuccaneer](https://github.com/AbigailBuccaneer)
* [Juan Julián Merelo Guervós](https://github.com/JJ)
* [Naoyuki Totani](https://github.com/ntotani)
* [Jennal](https://github.com/Jennal)
* [Victor Seva](https://github.com/linuxmaniac)
* [Urs Breu](https://github.com/ubreu)

### History 

#### Version 3.2 (in progress)
* distinguish between failures (failed assertion) and errors
* Support for new versions: Lua 5.3 and LuaJIT (2.0, 2.1), validated on Travis CI and AppVeyor
* Compatibility layer with forked luaunit v2.x added
* added documentation about development process
* improved support for table containing keys of type table
* small bug fixes, several internal improvements

#### Version 3.1 - 10 Mar. 2015
* luaunit no longer pollutes global namespace, unless defining EXPORT_ASSERT_TO_GLOBALS to true
* fixes and validation of JUnit XML generation
* strip luaunit internal information from stacktrace
* general improvements of test results with duration and other details
* improve printing for tables, with an option to always print table id
* fix printing of recursive tables 

**Important note when upgrading to version 3.1** : assertions functions are
no longer exported directly to the global namespace. See documentation for upgrade
paths.

#### Version 3.0 - 9. Oct 2014

Since some people have forked LuaUnit and release some 2.x version, I am
jumping the version number.

- moved to Github
- full documentation available in text, html and pdf at read-the-docs.org
- new output format: JUnit
- much better table assertions
- new assertions for strings, with patterns and case insensitivity: assertStrContains, 
  assertNotStrContains, assertNotStrIContains, assertStrIContains, assertStrMatches
- new assertions for floats: assertAlmostEquals, assertNotAlmostEquals
- type assertions: assertIsString, assertIsNumber, ...
- error assertions: assertErrorMsgEquals, assertErrorMsgContains, assertErrorMsgMatches
- improved error messages for several assertions
- command-line options to select test, control output type and verbosity

#### Version 2.0
Unofficial fork from version 1.3
- lua 5.2 module style, without global namespace pollution
- setUp() may be named Setup() or setup()
- tearDown() may be named Teardown() or teardown()
- wrapFunction() may be called WrapFunctions() or wrap_functions()
- run() may also be called Run()
- table deep comparision (also available in 1.4)
- control verbosity with setVerbosity() SetVerbosity() and set_verbosity()

#### Version 1.5 - 8. Nov 2012
- compatibility with Lua 5.1 and 5.2
- better object model internally
- a lot more of internal tests
- several internal bug fixes
- make it easy to customize the test output
- running test functions no longer requires a wrapper
- several level of verbosity


#### Version 1.4 - 26. Jul 2012
- table deep comparison
- switch from X11 to more popular BSD license
- add TAP output format for integration into Jenkins
- official repository now on github


#### Version 1.3 - 30. Oct 2007
- port to lua 5.1
- iterate over the test classes, methods and functions in the alphabetical order
- change the default order of expected, actual in assertEquals (adjustable with USE_EXPECTED_ACTUAL_IN_ASSERT_EQUALS).


#### Version 1.2 - 13. Jun 2005  
- first public release


#### Version 1.1
- move global variables to internal variables
- assertion order is configurable between expected/actual or actual/expected
- new assertion to check that a function call returns an error
- display the calling stack when an error is spotted
- two verbosity level, like in python unittest

