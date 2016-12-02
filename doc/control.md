# Sevenhugs Smart Remote SDK - writing a control script

## Overview

A control script is run directly on the remote.  It is given parameters which
are constructed by the configuration application and is responsible for
communicating with the device or service.

A control script defines a class which is instantiated when a target is
selected.  The control object is owned by a user interface (ui) object which
is instantiated according to its description.

The ui object will query the control object for the current state of the
controlled device or service.  It will also make requests to change the
current state or to send commands.  Every time the ui object makes a query, or
request, it expects that the control object responds with an error or a new
state.  While a response is expected, the ui object will not issue any other
query or request.

Scripts are written using lua 5.3.

## The control object, general interface

The target parameters are always available in the `self.params` table.

### Defining the control class

The class is defined using a helper function:

```lua
local control = require 'sevenhugs.remote.control'
local my_control = control.class()
```

### The `description` table

Define the `description` table in the class:

```lua
my_control.description = {
    icon = 'my_control_specific_icon',
    capability = 'light.dim',
}
```

- `icon` (optional): this names an icon specific to the controlled target to
  display instead of a generic one.
- `capability`: describe the features of the controlled target.  The set of
  available capabilities depends on the ui class.

### The `init` method

This is called when the target is selected.  Its definition is optional and
rarely needed.

```lua
function my_control:init()
    -- ...
end
```

### The `close` method

This is called when the target is unselected so that pending exchanges can be
shut down.  Its definition is optional.

```lua
function my_control:close()
    -- ...
end
```

### The `query` method

This is called to query the current state of the target when it is first
selected or when previous information expired.

```lua
function my_control:query(ui)
    -- To signal the response needs some time to arrive:
    ui:state()
    -- If all went well:
    ui:state(...)
    -- If something went wrong:
    ui:error('something went wrong')
end
```

### The `set`, `set_...` or `command` methods

These methods are to be defined according to the interface for the defined
capabilities.  They set the current state or attribute, or send a command.

```lua
function my_control:set(ui)
    -- To signal the response needs some time to arrive:
    ui:state()
    -- If all went well:
    ui:state(...)
    -- Lazy way to report state:
    self:query(ui)
    -- If something went wrong:
    ui:error('something went wrong')
end
```

### Do not forget to return the class!

At the end of your control script:

```lua
return my_control
```

## The ui object, general interface for control objects

### The `ui:state` method

This method must be called to report the current target state.

When called without argument (or if first argument is `nil`), this signals
that the target state is not known and is begin queried.  The user interface
will display a symbol to make the user wait.

```lua
ui:state()
```

When called with arguments, this reports the current state.  The precise set
of arguments depends of the defined capabilities.

```lua
ui:state(...)
```

> Planned evolution:
Future API will include a way to provide a expiration date for the given
information.  When it expires the ui object will query the control object for
updated state.

> Planned evolution:
Future API may pass arguments in a table instead of positional arguments.

### The `ui:error` method

This method must be called to report an error condition.  The given string is
useful for troubleshooting.

> Planned evolution:
Future API will include a way to give user friendly error messages in the user
language.
