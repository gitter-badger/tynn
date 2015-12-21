# Routing Basics

## Halting

To immediately stop a request within a route, you can use [Tynn#halt][halt]:

```ruby
halt([status, headers, body])
```

You can use [Tynn::Response#finish][finish] to return a response as per
Rack's specification.

```ruby
if current_user.nil?
  res.redirect("/login")

  halt(res.finish)
else
  # do something else ...
end
```

[finish]: /api/Tynn-Response.html#method-i-finish
[halt]: /api/Tynn.html#method-i-halt

## Doing Redirects

We can use the res object to ask the client to do a redirect. We can for example do it like this:

```ruby
Tynn.define do
  on 'old' do
    get do
      res.redirect '/new'
    end
  end

  on 'new' do
    get do
      res.write 'New!'
    end
  end
end
```

Ok, let's call this via `curl`: `curl http://localhost:9292/old`. The result is... surprising: It is empty. Let's check out the headers with `curl -i http://localhost:9292/old`:

```
HTTP/1.1 302 Found
Location: http://localhost:9292/new
...
```

What we see here is that the status code is a 302, which means that the resource behind this URL resides under a different URL now. The new URL is provided via the `Location` header we can see in the line below that. We can tell curl to follow redirects with the -L option, like this: `curl -L http://localhost:9292/old`. Now we will see `New!` as the result. A browser follows redirects by default.

## Setting status codes

Status codes are an essential part of HTTP communication. The default status code in Tynn is 200. We also saw that in certain cases Tynn will set it to a different value (for example if the request could not be matched it will be set to a 404 or in the case of a redirect to a 302). But what if you want to set it explicity?

```ruby
Tynn.define do
  on 'hello' do
    res.status = 501
  end
end
```

That's all!

## Response headers

To set a header in your response, you use `res.headers` hash like this:

```ruby
Tynn.define do
  on 'hello' do
    res.headers["Content-Type"] = "application/json"
    res.write "{\"result\":true}"
  end
end
```

## Cookies

Cookies are a very simple concept: Each cookie is a pair of key and value. The server tells the client to set a cookie. The client will then save this cookie locally and send it back to the server with every subsequent request. Let's try it out:

```ruby
Tynn.define do
  root do
    res.set_cookie "foo", "bar"
    res.write("Hello World!")
  end
end
```

Now, let's look at the response with the `-i` flag by calling `curl -i localhost:9292`. The result will contain the following line:

```
Set-Cookie: foo=bar
```

That means that the server responded with a header `Set-Cookie`. This tells a browser to store this key value pair. curl can also save cookies when told to by using the `-c` option with a filename to store the cookies. Let's try it: `curl -c cookies localhost:9292`. Now we have a file `cookies`, open it in your text editor and you will see the stored cookies.

Now let's try reading the cookie on the server side:

```ruby
Tynn.define do
  root do
    res.set_cookie "foo", "bar"
    res.write("Hello World!")
    res.write("Foo was #{req.cookies['foo']}")
  end
end
```

Now we can use the created cookie file via the `-b` option: `curl -b cookies localhost:9292`. We will see the value `bar` in our response. And those are the basics of cookies in Tynn and curl. One last hint: You can use the `-b` and `-c` option at the same time, so that you can read and write to the cookie file with every request: `curl -c cookies -b cookies localhost:9292`.
