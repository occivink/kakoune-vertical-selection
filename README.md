# kakoune-vertical-selection

**Warning**: For kakoune version 2021.11.08 and earlier, the master branch of this plugin will not work. The latest commit compatible with these versions is 6f46f8b510f1bf09904c00165ec25572567af0d6.

[kakoune](http://kakoune.org) plugin to copy the current selection up and downwards to all lines matching the current selection.

[![demo](https://asciinema.org/a/138331.png)](https://asciinema.org/a/138331)

## Setup

Add `vertical-selection.kak` to your autoload directory,`~/.config/kak/autoload`, or source it manually.

## Usage

The script defines three commands: `select-down`, `select-up` and `select-vertically`. They respectively select all lines directly below, above and both that contain the current selection at the same position.
Calling any of the commands with a multi-line selection is undefined behavior.


I suggest the following mappings:
```
map global user v     ': vertical-selection-down<ret>'
map global user <a-v> ': vertical-selection-up<ret>'
map global user V     ': vertical-selection-up-and-down<ret>'
```

See also [kakoune-text-objects](https://github.com/Delapouite/kakoune-text-objects), for integrating this plugin into your text objects.

## Tests

The `test.kak` file contains tests for the plugin. To execute these tests, simply run `kak -n -e 'source test.kak ; quit'`: if the kakoune instance stays open, the tests have somehow failed and the current state can be inspected.

## Trivia

This was suggested as a primitive by @rouanth on 2017-01-09
([#1115](https://github.com/mawww/kakoune/issues/1115))
and was followed by an implementation by patching the kakoune source code
([#1116](https://github.com/mawww/kakoune/pull/1116)).
The suggested keybinding in the patch was `^`.

* [#1115](https://github.com/mawww/kakoune/issues/1115): Binding to copy selections vertically to equal substrings
* [#1116](https://github.com/mawww/kakoune/pull/1116): Keybinding for copying selections on matching substrings vertically


## License

Unlicense
