# Sevenhugs Smart Remote SDK - writing a speaker control script

## Overview

Please first read [writing a control script](control.md).

A light control script must have capability `speaker`.

> Planned evolution:
Future API will have different capabilities for different class of speaker
(simple one with only volume control, smarter one with playlist control, even
smarter one with song name and attributes...).

## The `ui:state` method arguments

```lua
ui:state(state, volume)
```

- `state`: this is `true` for playing and `false` for stopped or paused.
- `volume`: this is current volume between 0.0 and 1.0.

> Planned evolution:
Future API will have arguments for possible actions (is next allowed?),
current track number, total number of tracks, current track time position,
current track length, current track name and attributes...

## The `set_state` control method

```lua
function my_control:set_state(ui, state)
    -- ...
end
```

- `state`: this is `true` to request playing and `false` to request pause.

## The `set_volume` control method

```lua
function my_control:set_volume(ui, volume)
    -- ...
end
```

- `volume`: same meaning as the `ui:state` argument.

## The `command` control method

```lua
function my_control:command(ui, command)
    -- ...
end
```

- `command`: this can be:
    - `next`: to request next song in playlist,
    - `previous`: to request previous song in playlist.

