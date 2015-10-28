title: Rendering Templates

It's easy to render templates. You can use [HMote][hmote]:

    require "tynn"
    require "tynn/hmote"

    Tynn.plugin(Tynn::HMote)

Or your favorite template engine:

    require "erubis"
    require "tynn"
    require "tynn/render"

    Tynn.plugin(Tynn::Render)

[hmote]: https://github.com/harmoni/hmote
