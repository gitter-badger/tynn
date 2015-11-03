# Default Plugins

Tynn ships with a set of default plugins. Here is a complete list:

| Name                               | Description
| ---------------------------------- | --------------------------------------------------------------------
| [Tynn::AllMethods][t-all_methods]  | Adds matchers for HTTP's HEAD and OPTIONS methods.
| [Tynn::Environment][t-environment] | Adds helper methods to get and check the current environment.
| [Tynn::HMote][t-hmote]             | Adds support for rendering [HMote][hmote] templates.
| [Tynn::JSON][t-json]               | Adds helper methods for json generation.
| [Tynn::Matchers][t-matchers]       | Adds extra matchers.
| [Tynn::NotFound][t-not_found]      | Adds support for handling 404 responses.
| [Tynn::Protection][t-protection]   | Adds security measures against common attacks.
| [Tynn::Render][t-render]           | Adds support for rendering templates through different engines.
| [Tynn::Session][t-session]         | Adds simple cookie based session management.
| [Tynn::Static][t-static]           | Adds support for static files (javascript files, images, etc.).

Check [lib/tynn](https://github.com/frodsan/tynn/tree/master/lib/tynn)
to have a look at their implementations.

[hmote]: https://github.com/harmoni/hmote

[t-all_methods]: /api/Tynn-AllMethods.html
[t-environment]: /api/Tynn-Environment.html
[t-hmote]: /api/Tynn-HMote.html
[t-json]: /api/Tynn-JSON.html
[t-matchers]: /api/Tynn-Matchers.html
[t-not_found]: /api/Tynn-NotFound.html
[t-protection]: /api/Tynn-Protection.html
[t-render]: /api/Tynn-Render.html
[t-session]: /api/Tynn-Session.html
[t-static]: /api/Tynn-Static.html
