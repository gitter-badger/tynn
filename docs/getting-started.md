# Getting Started

To get started, install Tynn:

```no-highlight
$ gem install tynn
```

Open your preferred text editor and create a file called `config.ru` with the
following code:

```ruby
require "tynn"

Tynn.define do
  root do
    res.write("Hei World!")
  end
end

run(Tynn)
```

You already have a functional application. To see it in action, start a web
server by typing `rackup config.ru` in the command line.

```no-highlight
$ rackup config.ru
[2015-10-12 19:16:31] INFO  WEBrick 1.3.1
[2015-10-12 19:16:31] INFO  ruby 2.2.3 (2015-08-18) [x86_64-darwin13]
[2015-10-12 19:16:31] INFO  WEBrick::HTTPServer#start: pid=71406 port=9292
```

> **NOTE:** To stop the web server, press `Ctrl+C`.

Open the browser and navigate to <http://localhost:9292> to see the
greeting message.
