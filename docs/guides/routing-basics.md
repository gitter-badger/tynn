# Routing Basics

## Halting

To immediately stop a request within a route, you
can use [Tynn#halt][halt]:

```ruby
halt([status, headers, body])
```

You must pass a response as per Rack's specification,
an array of three elements: status, headers and body.

```ruby
on(current_user.nil?) do
  res.redirect("/login")

  halt(res.finish)
end
```

[halt]: /api/Tynn.html#method-i-halt
