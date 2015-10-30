# Testing

Tynn ships with [Tynn::Test][tynn-test], a simple helper class to simulate
requests to your application.

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

Check [Tynn::Test][tynn-test] for more information about usage.

[tynn-test]: /api/Tynn-Test.html
