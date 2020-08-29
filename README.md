# arcologies

_an interactive environment for designing 2d sound arcologies with norns and grid_

![arcologies](https://tyleretters.github.io/arcologies-docs/assets/images/arcologies-landscape.jpg)

If you are an artist, musician, or arcologist here to use this tool, [everything you need to know is in the docs](https://tyleretters.github.io/arcologies-docs).

This README is for developers looking to contribute in building **arcologies**.

## Technical

- To learn the codebase, read [arcologies.lua](https://github.com/tyleretters/arcologies/blob/main/arcologies.lua) and [lib/includes.lua](https://github.com/tyleretters/arcologies/blob/main/lib/includes.lua).
- Next, skim through [keeper.lua](https://github.com/tyleretters/arcologies/blob/main/lib/keeper.lua), [Cell.lua](https://github.com/tyleretters/arcologies/blob/main/lib/Cell.lua), [Signal.lua](https://github.com/tyleretters/arcologies/blob/main/lib/Signa.lua), and [counters.lua](https://github.com/tyleretters/arcologies/blob/main/lib/counters.lua).
- `Cell` and `Signal` are the only [classes](https://www.lua.org/pil/16.1.html). Signals are primitive. Cells are complex.
- [config.lua](https://github.com/tyleretters/arcologies/blob/main/lib/config.lua) is where signal, cellular, and global behavior is composed.
- Cell traits/mixins are inside [lib/traits](https://github.com/tyleretters/arcologies/blob/main/lib/traits). Even though there are many different types of cell structures, they're all just instances of the same Cell class. Changing (e.g. `cell:change("TOPIAR")`) their structure toggles behaviors and traits on and off.
- Saving and loading is rudimentary and perhaps fragile. As the project evolves I'd like to take care and keep things as backwards-compatible as possible. May [athens.arcology](https://gist.github.com/tyleretters/384db1a15e645440141a627fdead50d9) always load!

## Contributing

Contributions are welcome, however I have some pretty firm boundaries about what **arcologies** is and is not. If you have an idea for a significant undertaking that you'd like to contribute, please consider talking with me first. I'd hate to see you pour a bunch of energy into a feature that doesn't align with the vision. That said, I'll consider all feature requests! Thank you.