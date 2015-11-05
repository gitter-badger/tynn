# Getting Started

To get started, install the following gems:

```no-highlight
$ gem install tynn
$ gem install tynn-generator
```

Now, create a minimal application with:

```ruby
$ tynn myapp
   create : myapp
   create : myapp/app.rb
   create : myapp/config.ru
```

You already have a functional application. To see it in action, switch
to the application's folder and start a web server by typing `rackup`
in the command line.

```no-highlight
$ cd myapp
$ rackup
[2015-10-12 19:16:31] INFO  WEBrick 1.3.1
[2015-10-12 19:16:31] INFO  ruby 2.2.3 (2015-08-18) [x86_64-darwin13]
[2015-10-12 19:16:31] INFO  WEBrick::HTTPServer#start: pid=71406 port=9292
```

> **NOTE:** To stop the web server, press `Ctrl+C`.

Then, open <http://localhost:9292> in a browser to see the greeting message.
