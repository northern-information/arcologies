# arcologies

_an interactive environment for designing 2d sound arcologies with norns and grid_

![Latest Release](https://img.shields.io/github/v/release/northern-information/arcologies?sort=semver&color=%23f)

![arctangents & archangels](https://northern-information.github.io/arcologies-docs/assets/images/arctangents-and-archangels.jpg)

![eternal september](https://northern-information.github.io/arcologies-docs/assets/images/eternal-september.jpg)

![arcologies](https://northern-information.github.io/arcologies-docs/assets/images/arcologies-landscape.jpg)

If you are an artist, musician, or arcologist here to use this tool, [everything you need to know is in the docs](https://northern-information.github.io/arcologies-docs). Join the discussion on [lines](https://l.llllllll.co/arcologies).

This README is for developers looking to contribute in building **arcologies**.

## Changelog

[The changelog is located here.](https://northern-information.github.io/arcologies-docs#changelog)

## Technical

- The [developer manual video](https://www.youtube.com/watch?v=NJlO2jajM6k) is the fastest way to learn **arcologies**. It includes a walkthrough of the architecture and deep dives into the most complex parts of the software.
- To learn the codebase, read [arcologies.lua](https://github.com/northern-information/arcologies/blob/main/arcologies.lua) and [lib/includes.lua](https://github.com/northern-information/arcologies/blob/main/lib/includes.lua).
- Next, skim through [keeper.lua](https://github.com/northern-information/arcologies/blob/main/lib/keeper.lua), [Cell.lua](https://github.com/northern-information/arcologies/blob/main/lib/Cell.lua), [Signal.lua](https://github.com/northern-information/arcologies/blob/main/lib/Signal.lua), and [counters.lua](https://github.com/northern-information/arcologies/blob/main/lib/counters.lua).
- `Cell` and `Signal` are the only [classes](https://www.lua.org/pil/16.1.html). Signals are primitive. Cells are complex.
- [config.lua](https://github.com/northern-information/arcologies/blob/main/lib/config.lua) is where signal, cellular, and global behavior is composed.
- Cell traits/mixins are inside [lib/mixins](https://github.com/northern-information/arcologies/blob/main/lib/mixins). Even though there are many different types of cell structures, they're all just instances of the same Cell class. Changing their structure toggles behaviors and traits on and off (e.g. `cell:change("TOPIARY")` will update the structure of the selected cell, hide the attributes that no longer apply, and activate the topiary attributes).
- Saving and loading (`fn.collect_data_for_save()` & `fn.load()`) is rudimentary and perhaps fragile. As the project evolves I'd like to take care and keep things as backwards-compatible as possible. May [athens.arcology](https://gist.github.com/tyleretters/384db1a15e645440141a627fdead50d9) always load!

## Contributing

Contributions are welcome, however I have some pretty firm boundaries about what **arcologies** is and is not. I recommend watching [all the videos in this playlist](https://www.youtube.com/playlist?list=PLe1BFUbUceS2N5GLgORKQrw1bsz2ZLwJ3) to get inside my head a bit more. If you have an idea for a significant undertaking that you'd like to contribute, please consider talking with me first. I'd hate to see you pour a bunch of energy into a feature that doesn't align with the vision. That said, I'll consider all feature requests! Thank you.

## Credits

Software design by [Tyler Etters](https://nor.the-rn.info).
