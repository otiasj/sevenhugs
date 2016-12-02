# Sevenhugs Smart Remote SDK - writing a light control script

## Overview

Please first read [writing a control script](control.md).

A light control script must have capability `light.switch` or `light.dim`.

> Planned evolution:
Future API will include `light.color`.

## The `ui:state` method arguments

```lua
ui:state(state) -- for light.switch
ui:state(state, brightness) -- for light.dim
```

- `state`: this is `true` for light on and `false` for light off.
- `brightness`: this is light intensity between 0.0 and 1.0.  The brightness
  0.0 represents the minimum light intensity which is not off.

## The `set` control method

```lua
function my_control:set(ui, state) -- for light.switch
    -- ...
end

function my_control:set(ui, state, brightness) -- for light.dim
    -- ...
end
```

The `state` and `brightness` arguments have the same meaning as those of the
`ui:state` method.
