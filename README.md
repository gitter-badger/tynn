# Tynn

A thin library for web development in Ruby.

* [Installation](#installation)
* [Getting Started](#getting-started)
  * [Hello World!](#hello-world)
  * [Capturing Path Segments and the Inbox](#capturing-path-segments-and-the-inbox)
  * [Handling Request and Response](#handling-request-and-response)
  * [Composing Applications](#composing-applications)
  * [Extending Tynn](#extending-tynn)
* [Routing Basics](#routing-basics)
  * [Halting](#halting)
* [Middleware](#middleware)
* [Plugins](#plugins)
* [Settings](#settings)
* [Environments](#environments)
* [Method Override](#method-override)
* [Static Files](#static-files)
* [Testing](#testing)
* [API Reference](http://api.tynn.xyz/2.0.0)
* [Changelog](#changelog)
* [Development](#development)
* [Contributing](#contributing)
* [Code Status](#code-status)
* [License](#license)

**NOTE: Tynn 2 is in an alpha phase. Anything can change at any time. Usage is not recommended until a stable version gets released.**

## Installation

```
$ gem install tynn
```

## Getting Started

In this tutorial we will assume that you have basic knowledge about HTTP and Ruby. You will learn about Rack, Tynn and cURL along the way. To code along all you need to do is `gem install tynn` and then create a folder that should contain your first app.

### Hello World!

Tynn is a routing library that sits on top of Rack. So in order to get your first Tynn app running, we need to write a `config.ru` file. This file is used by Rack to find an application and run it. The most basic version of `config.ru` file looks like this:

```ruby
require File.expand_path("app", __dir__)

run(Tynn)
```

This will require the `app.rb` file in the current directory and then run the Rack application that is contained in it. So let's write the `app.rb` file:

```ruby
require "tynn"

Tynn.define do
  res.write("Hello World!")
end
```

In this file we first require the Tynn library, then we define our application. It will write "Hello World" to something called `res`. In Tynn, `res` is the result of the request. So in other words: Our application will answer with `"Hello World"`.

To run this application now, we will use a commandline tool called `rackup`. It is included in the Rack gem, so you already have it installed. You run it like this:

```
rackup
```

It will then boot up and tell you something like this:

```
[2015-11-30 17:27:37] INFO  WEBrick 1.3.1
[2015-11-30 17:27:37] INFO  ruby 2.2.2 (2015-04-13) [x86_64-linux]
[2015-11-30 17:27:37] INFO  WEBrick::HTTPServer#start: pid=25355 port=9292
```

This means that we are using [WEBrick](http://ruby-doc.org/stdlib-2.2.3/libdoc/webrick/rdoc/index.html) from the Ruby standard library as our web server, and we are using the port 9292. So now you can either type `localhost:9292` in your browser of choice or use curl. curl is probably installed on your system already. If it is not, you can find information on how to install it [here](http://curl.haxx.se/docs/install.html). In a second terminal (while your server keeps running in the first one), type:

```
curl localhost:9292
```

The result will be:

```
Hello World!
```

Congratulations, you now have your first working Tynn app! But wait, on what path does it listen? As we've seen above, it definitely listens on the root path. But what about the other paths? Let's try it out with `curl localhost:9292/somepath` – and you will see the same result! Our app listens on all paths. Let's change that to only responding to the root path:

```ruby
Tynn.define do
  root do
    res.write("Hello World!")
  end
end
```

Now `curl localhost:9292` will still return the greeting, but `curl localhost:9292/somepath` will return an empty response. As the request was not matched, it will also return a 404 status code which means "not found" in HTTP speak. You can check that with curl using the `-i` option: `curl -i localhost:9292/somepath`. If you want to learn more about status codes, check out the [Wikipedia page](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes).

Ok, so now you know how to react to the root path only. Let's continue with checking for the HTTP method. If you are not familiar with HTTP methods, check out [this Wikipedia page](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods). By default, curl does a GET request. Let us try a POST request instead: `curl -d "" localhost:9292` (the `""` is just an empty body for the post request). The result is the same as for the GET request. How can we restrict it to only react to GET requests?

```ruby
Tynn.define do
  root do
    get do
      res.write("Hello World!")
    end
  end
end
```

Now you might want to match to another path than the root path as well, so let's try this:

```ruby
Tynn.define do
  root do
    get do
      res.write("Hello World!")
    end
  end

  on("tynn") do
    get do
      res.write("Hello Tynn!")
    end
  end
end
```

Now we will get `Hello World` when we GET the root path, `Hello Tynn` when we GET the Tynn path and a 404 when we do anything else. Now one more thing about `on`: It is very flexible. You can either give it a single segment of the path (like above) or give it an entire path (like `on('a/pretty/long/path')`). You can also nest it, and this is what makes it really flexible:

```ruby
on("hello") do
  on("tynn") do
    get do
      res.write("Hello Tynn!")
    end
  end
end
```

Now you know the basics of Tynn – but there is still more to learn. Keep exploring this page!

### Capturing Path Segments and the Inbox

We now know how to handle static URLs and different request methods. But what about dynamic parts in the request, like an ID or the name of a blog post? Tynn has you covered:

```ruby
Tynn.define do
  on("hello") do
    on(:name) do
      get do
        res.write("Hello Tynn!")
      end
    end
  end
end
```

This will work for all URLs that have `hello` as their first segment and some other string as the second segment. For example `/hello/tynn` or `/hello/world`. Notice however that it will not match `/hello/beautiful/world`, as it has a third segment which we don't match (`world`). When you provide `on` with a String then it matches it as an exact match (of one or more segments), if you provide a symbol it matches a single segment regardless of what it is.

Our current application will always greet the user with the same message, regardless of the second segment. If we want to change that, we need to access the value of the second segment. This is where the inbox comes in. The inbox is a hash, which in our example has a key `:name` with the value set to the segment. So let's use that:

```ruby
Tynn.define do
  on("hello") do
    on(:name) do
      get do
        res.write("Hello #{inbox[:name]}!")
      end
    end
  end
end
```

With this change, the visitor will now be greeted with what they provided in the URL. So for example `curl -i localhost:9292/hello/alice` will reply with `hello alice`. You can nest the `on` calls in any way you like, so you can also match URLs like `/people/:name/articles`.

### Handling Request and Response

When handling HTTP requests, you have a `req` and a `res` object available inside your `Tynn.define` block:

* `req` is an instance of [Tynn::Request](http://www.rubydoc.info/github/frodsan/tynn/master/Tynn/Request) and provides information about the request.
* `res` is an instance of [Tynn::Response](http://www.rubydoc.info/github/frodsan/tynn/master/Tynn/Response) and provides information about the response.

In this section of the tutorial, we will go through accessing parameters. For more information about routing, check out [the guide](/routing-basics.html). The request object `req` gives you access to all parameters. When we say "parameters" we mean two things:

* The data received from the [Query String](https://en.wikipedia.org/wiki/Query_string)
* The data received from the [HTTP message body](https://en.wikipedia.org/wiki/HTTP_message_body)

Let's start with the query string. The query string is a part of an URL and can therefore occur in every kind of request. It is a collection of key value pairs. The URL `http://localhost:9292/hello/alice?a=12&b=hello` for example has two pairs of key and value: `a` has the value `"12"` and `b` has the value `"hello"`. We can access them via the `[]` method on Tynn::Request:

```ruby
Tynn.define do
  on("hello") do
    on(:name) do
      get do
        res.write("Hello #{inbox[:name]} with your 'a' being '#{req['a']}'!")
      end
    end
  end
end
```

Now let's try it out by sending the request via curl: `curl -i "http://localhost:9292/hello/alice?a=12&b=hello"` and we will see `Hello alice with your 'a' being '12!'`. Be aware that the value will be `nil` when the key is not in the query string (it behaves like a Ruby Hash). Note that another name for this kind of parameter is a "Get parameter", because an HTML form using the GET method with use a query string to transmit its data. You can however use it with any method not just GET.

The other kind of parameters is the information stored in the HTTP message body. The body can contain any kind of data – for example JSON encoded data or binary data. One way this is used is when you submit an HTML form with the `POST` method. The body is then encoded in a way that is called "form URL encoded". The format is described [here](https://en.wikipedia.org/wiki/Percent-encoding#The_application.2Fx-www-form-urlencoded_type) for example. curl speaks this encoding fluently, so we can use it like this: `curl -d "name=Daniel%20Stenberg&occupation=Hacker" http://localhost:9292/hello/alice`. curl does a few things for us: It sets the request method to POST, sets the content type to `application/x-www-form-urlencoded`, determines the content length and sets the body. Now how to we react to that in our Tynn app?

```ruby
Tynn.define do
  on("hello") do
    on(:name) do
      post do
        res.write("Created user '#{req['name']}' with occupation '#{req['occupation']}'")
      end
    end
  end
end
```

If you try it out with `curl -d "name=Daniel%20Stenberg&occupation=Hacker" http://localhost:9292/hello/alice` you will get a response stating `Created user 'Daniel Stenberg' with occupation 'Hacker'`. As you can see, we use the same method to access these parameters as we did for the parameters in the query part of our URL. Another common usage for the body is sending JSON encoded data, for example when talking to an API. We can do that with curl as follows (sending the same content, just encoded differently): `curl -H "Content-Type: application/json" -X POST -d '{"name": "Daniel Stenberg", "occupation": "Hacker"}' http://localhost:9292/hello/alice`. As Tynn doesn't understand JSON natively in the same way it does form encoded data, we have to do the following:

```ruby
require "json"

Tynn.define do
  on("hello") do
    on(:name) do
      post do
        if req.content_type == "application/json"
          user = JSON.parse(req.body.read)
          res.write("Created user '#{user['name']}' with occupation '#{user['occupation']}'")
        end
      end
    end
  end
end
```

We do two things here: We check if the content type is set correctly, and if it is, we parse the body of the request as JSON and then do what we did before. The result therefore will be the same as in the form encoded example. Note that not all HTTP methods support sending a body. Notably GET and HEAD **do not support** it.

### Composing Applications

At this point you may wonder if you need to put your entire routing logic or even application into one giant Tynn application. No, you don't need to. In fact, composing applications is one of the guiding principles of Tynn.

In our examples so far we only had one Tynn app. What if we want to create a second one?

```ruby
class Users < Tynn
end

Users.define do
  # ... add handlers here
end
```

We can run a Tynn inside of another app. We can for example use this to run our `Users` app for all routes that start with `/users` like this:

```ruby
class Users < Tynn
end

Users.define do
  get do
    res.write("All the users")
  end

  on(:id) do
    get do
      res.write("Only the user with ID #{inbox[:id]}")
    end
  end
end

Tynn.define do
  on("users") do
    run(Users)
  end
end
```

### Extending Tynn

Tynn is minimal. You might miss features from time to time. Tynn is designed to be extended, so you add the functionality that you need. There are two ways to extend it:

* [Plugins](/plugins.html) via `plugin`: Add class and instance methods to your application.
* [Middleware](/middleware.html) via `use`: Rewrite requests before they enter your application and responses after they left your application.

Tynn also ships with some [default plugins](/default-plugins.html) that you can add to your application if you need them.

## Routing basics

### Halting

To immediately stop a request within a route, you can use the `halt` method.

```ruby
halt([status, headers, body])
```

You can use `res.finish` to return a response as per Rack's specification.

```ruby
if current_user.nil?
  res.redirect("/login")

  halt(res.finish)
else
  # do something else ...
end
```

## Middleware

Tynn runs on [Rack](https://github.com/rack/rack). Therefore it is possible
to use Rack middleware in Tynn. This is how you add a middleware (for example
`YourMiddleware`) to your app:

```ruby
Tynn.use(YourMiddleware)
```

You can use any Rack middleware to your app, it is not specific to Tynn. You
can find a list of Rack middleware [here][middleware].

[middleware]: https://github.com/rack/rack/wiki/list-of-middleware

## Plugins

A way to extend Tynn is to use the plugin API. A plugin is just a module which can contain any of the following rules:

- If a `ClassMethods` module is defined, it extends the application class.

- If a `InstanceMethods` module is defined, it's included in the application.

- If a `setup` method is defined, it will be called last. This method can be used to configure the plugin.

The following is a complete example of the plugin API.

```ruby
require "valuta"

module CurrencyHelper
  def self.setup(app, currency: "$")
    self.currency = currency
  end

  module ClassMethods
    def currency
      @currency
    end

    def currency=(currency)
      @currency = currency
    end
  end

  module InstanceMethods
    def to_currency(value)
      Valuta.convert(value, prefix: self.class.currency)
    end
  end
end
```

To load the plugin into the application, use the `plugin` method.

```ruby
App.plugin(CurrencyHelper, currency: "$")
```

Here is the plugin in action:

```ruby
App.currency # => "$"

App.define do
  get do
    res.write(to_currency(4567))
  end
end
# GET / => 200 $4,567
```

## Settings

Each application has a `settings` hash where configuration can be stored. By default, settings are inherited.

```ruby
Tynn.set(:layout, "layout")

class Guests < Tynn; end
class Users < Tynn; end
class Adminds < Tynn; end

Users.set(:layout, "users/layout")
Admins.set(:layout, "admins/layout")

Guests.settings[:layout] # => "layout"
Users.settings[:layout]  # => "users/layout"
Admins.settings[:layout] # => "admins/layout"
```

This features comes in handy when authoring plugins.

```ruby
module CurrencyHelper
  module ClassMethods
    def currency=(currency)
      set(:currency, currency)
    end

    def currency
      settings.fetch(:currency, "$")
    end
  end
end
```

## Environments

Tynn ships with [Tynn::Environment] to set and check the current environment for the application.

```ruby
require "tynn"
require "tynn/environment"

Tynn.plugin(Tynn::Environment)
```

The default environment is based on the `RACK_ENV` environment variable.

```ruby
ENV["RACK_ENV"]
# => "test"

Tynn.environment
# => :test
```

If `ENV["RACK_ENV"]` is `nil`, the default value is `:development`.

```ruby
Tynn.environment
# => :development
```

To change the current environment, use the `environment=` method.

```ruby
Tynn.environment = :development

Tynn.environment
# => :development
```

To check the current environment, use: `development?`, `test?`,
`production?` or `staging?`.

```ruby
Tynn.plugin(Tynn::Protection, ssl: Tynn.production?)
```

Perform operations on specific environments with the `configure` method.

```ruby
Tynn.configure(:development) do |app|
  app.use(Tynn::Static, %w(/js /css /images))
end

Tynn.configure(:production) do |app|
  app.use(Tynn::SSL)
end
```

## Method Override

HTML Forms only support GET and POST requests. To perform other actions such as PUT, PATCH or DELETE, use the [Rack::MethodOverride] middleware. Note that there is no need to add any new dependencies to the application as it's included in Rack already.

```ruby
Tynn.use(Rack::MethodOverride)
```

This uses a POST form to simulate a request with a non-supported method. In order to succeed, a hidden input field, with the name `_method` and the method name as the value, needs to be included. The following example simulates a PUT
request.

```html
<form method="POST" action="/posts/1">
  <input type="hidden" name="_method" value="PUT">
  <!-- ... -->
</form>
```

Now, this will trigger the `put` matcher in the application.

```ruby
Posts.define do
  put do
    post.update(req.params["post"])
  end
end
```

## Static Files

Tynn ships with [Tynn::Static] to serve static files such as images, CSS, JavaScript and others.

```ruby
require "tynn"
require "tynn/static"

Tynn.plugin(Tynn::Static, %w(/js /css /images))
```

By default, static files are served from the folder `public` in the current directory. You can specify a different location by passing the `:root` option:

```ruby
Tynn.plugin(Tynn::Static, %w(/js /css /images), root: "assets")
```

As you can see in the table below, the name of static directory is not included in the URL because the files are looked up relative to that directory.


| File                         | URL                                    |
| ---------------------------- | -------------------------------------- |
| ./public/js/application.js   | http://example.org/js/application.js   |
| ./public/css/application.css | http://example.org/css/application.css |
| ./public/images/logo.png     | http://example.org/images/logo.png     |

It's important to mention that the path of the static directory path is relative to the directory where you run the application. If you run the application from another directory, it's safer to use an absolute path:

```ruby
Tynn.plugin(
  Tynn::Static,
  %w(/js /css /images),
  root: File.expand_path("public", __dir__)
)
```

Testing
-------

Tynn ships with [Tynn::Test], a simple helper class to simulate requests to your application.

```ruby
require "tynn"
require "tynn/test"

Tynn.define do
  root do
    res.write("hei")
  end
end

app = Tynn::Test.new
app.get("/")

200   == app.res.status # => true
"hei" == app.res.body   # => true
```

[Tynn::Test] is test-framework agnostic. The following example uses [Minitest]:

```ruby
require "minitest/autorun"
require "tynn/test"

class GuestsRouteTest < Minitest::Test
  def setup
    @app = Tynn::Test.new
  end

  def test_home
    @app.get("/")

    assert_equal 200, @app.res.status
    assert_equal "Hello World!", @app.res.body
    assert_equal "text/html", @app.res["Content-Type"]
  end
end
```

If this is not of your flavor, you can use any Rack-based testing library or framework, like: [Rack::Test] or [Capybara].

## Changelog

To learn about new features, bug fixes, and changes, please refer to the [CHANGELOG](https://github.com/frodsan/tynn/blob/master/CHANGELOG.md).

## Development

Fork the project with:

```
$ git clone git@github.com:frodsan/tynn.git
```

To install dependencies, use:

```
$ bundle install
```

To run the test suite, do:

```
$ rake test
```

## Contributing

Use [GitHub Issues](https://github.com/frodsan/tynn/issues) for reporting bugs, discussing features and general feedback. If you've found a problem in Tynn, be sure to check the [past issues](https://github.com/frodsan/tynn/issues?state=closed) before open a new one.

## Code Status

[![Build Status](https://travis-ci.org/frodsan/tynn.svg?branch=master)](https://travis-ci.org/frodsan/tynn)

[![Build History](https://buildstats.info/travisci/chart/frodsan/tynn?branch=master)](https://travis-ci.org/frodsan/tynn/builds)

## License

Tynn is released under the [MIT License](http://www.opensource.org/licenses/MIT).

[capybara]: https://github.com/jnicklas/capybara
[minitest]: https://github.com/seattlerb/minitest
[rack::test]: https://github.com/brynary/rack-test
[rack::methodoverride]: http://www.rubydoc.info/github/rack/rack/Rack/MethodOverride
[tynn::environment]: http://api.tynn.xyz/2.0.0/Tynn/Environment.html
[tynn::render]: http://api.tynn.xyz/2.0.0/Tynn/Render.html
[tynn::static]: http://api.tynn.xyz/2.0.0/Tynn/Static.html
[tynn::test]: http://api.tynn.xyz/2.0.0/Tynn/Test.html
