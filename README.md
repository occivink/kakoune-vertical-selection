# kakoune-vertical-selections

[kakoune](http://kakoune.org) plugin to copy the current selection up and downwards to all lines matching the current selection.

See this [asciinema](https://asciinema.org/a/138331) for a quick demo.

## Setup

Add `vertical-selection.kak` to your autoload directory,`~/.config/kak/autoload`, or source it manually.

## Usage

The script defines three commands: `select-down`, `select-up` and `select-vertically`. They respectively select all lines directly below, above and both that contain the current selection at the same position.
Calling any of the commands with a multi-line selection is undefined behavior.


I suggest the following mappings:
```
map global user v :select-down<ret>
map global user <a-v> :select-up<ret>
map global user V :select-vertically<ret>
```

## License

Unlicense
