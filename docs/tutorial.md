# Tutorial

In this tutorial we will assume that you have basic knowledge about HTTP and Ruby. You will learn about Rack, Tynn and cURL along the way. To code along all you need to do is `gem install tynn` and then create a folder that should contain your first app.

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

  on('tynn') do
    get do
      res.write("Hello Tynn!")
    end
  end
end
```

Now we will get `Hello World` when we GET the root path, `Hello Tynn` when we GET the Tynn path and a 404 when we do anything else. Now one more thing about `on`: It is very flexible. You can either give it a single segment of the path (like above) or give it an entire path (like `on('a/pretty/long/path')`). You can also nest it, and this is what makes it really flexible:

```ruby
on('hello') do
  on('tynn') do
    get do
      res.write("Hello Tynn!")
    end
  end
end
```

Now you know the basics of Tynn – but there is still more to learn. Keep exploring this page!

## Capturing Path Segments and the Inbox

We now know how to handle static URLs and different request methods. But what about dynamic parts in the request, like an ID or the name of a blog post? Tynn has you covered:

```ruby
Tynn.define do
  on('hello') do
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
  on('hello') do
    on(:name) do
      get do
        res.write("Hello #{inbox[:name]}!")
      end
    end
  end
end
```

With this change, the visitor will now be greeted with what they provided in the URL. So for example `curl -i localhost:9292/hello/alice` will reply with `hello alice`. You can nest the `on` calls in any way you like, so you can also match URLs like `/people/:name/articles`.

## Handling Request and Response

When handling HTTP requests, you have a `req` and a `res` object available inside your `Tynn.define` block:

* `req` is an instance of [Tynn::Request](http://tynn.xyz/api/Tynn-Request.html) and provides information about the request.
* `res` is an instance of [Tynn::Response](http://tynn.xyz/api/Tynn-Response.html) and provides information about the response.

In this section of the tutorial, we will go through accessing parameters. For more information about routing, check out [the guide](/guides/routing-basics.html). The request object `req` gives you access to all parameters. When we say "parameters" we mean two things:

* The data received from the [Query String](https://en.wikipedia.org/wiki/Query_string)
* The data received from the [HTTP message body](https://en.wikipedia.org/wiki/HTTP_message_body)

Let's start with the query string. The query string is a part of an URL and can therefore occur in every kind of request. It is a collection of key value pairs. The URL `http://localhost:9292/hello/alice?a=12&b=hello` for example has two pairs of key and value: `a` has the value `"12"` and `b` has the value `"hello"`. We can access them via the `[]` method on Tynn::Request:

```ruby
Tynn.define do
  on('hello') do
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
  on('hello') do
    on(:name) do
      post do
        res.write "Created user '#{req['name']}' with occupation '#{req['occupation']}'"
      end
    end
  end
end
```

If you try it out with `curl -d "name=Daniel%20Stenberg&occupation=Hacker" http://localhost:9292/hello/alice` you will get a response stating `Created user 'Daniel Stenberg' with occupation 'Hacker'`. As you can see, we use the same method to access these parameters as we did for the parameters in the query part of our URL. Another common usage for the body is sending JSON encoded data, for example when talking to an API. We can do that with curl as follows (sending the same content, just encoded differently): `curl -H "Content-Type: application/json" -X POST -d '{"name": "Daniel Stenberg", "occupation": "Hacker"}' http://localhost:9292/hello/alice`. As Tynn doesn't understand JSON natively in the same way it does form encoded data, we have to do the following:

```ruby
require 'json'

Tynn.define do
  on('hello') do
    on(:name) do
      post do
        if req.content_type == 'application/json'
          user = JSON.parse(req.body.read)
          res.write "Created user '#{user['name']}' with occupation '#{user['occupation']}'"
        end
      end
    end
  end
end
```

We do two things here: We check if the content type is set correctly, and if it is, we parse the body of the request as JSON and then do what we did before. The result therefore will be the same as in the form encoded example. Note that not all HTTP methods support sending a body. Notably GET and HEAD **do not support** it.

## Composing Applications

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
    res.write('All the users')
  end

  on :id do
    get do
      res.write("Only the user with ID #{inbox[:id]}")
    end
  end
end

Tynn.define do
  on 'users' do
    run(Users)
  end
end
```

## Extending Tynn

Tynn is minimal. You might miss features from time to time. Tynn is designed to be extended, so you add the functionality that you need. There are two ways to extend it:

* [Plugins](/guides/plugins.html) via `plugin`: Add class and instance methods to your application.
* [Middlewares](/guides/middleware.html) via `use`: Rewrite requests before they enter your application and responses after they left your application.

Tynn also ships with some [default plugins](/guides/default-plugins.html) that you can add to your application if you need them.
