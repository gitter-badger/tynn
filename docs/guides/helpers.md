# Helpers

One way to extend Tynn, it's to use pure Ruby modules. Here is a simple one:

```ruby
module TextHelpers
  def markdown(str)
    return Markdown.new(str).to_html
  end
end
```

You can include the module into the application class:

```ruby
Tynn.include(TextHelpers)
```

The methods defined in the module will be available in
the application handler:

```ruby
Tynn.define do
  get do
    res.write(markdown("# some markdown here ..."))
  end
end
```
