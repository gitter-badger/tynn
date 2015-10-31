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
