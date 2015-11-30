# Helpers

One way to extend Tynn is to use pure Ruby modules. Here is a simple one:

```ruby
module TextHelpers
  def markdown(str)
    Markdown.new(str).to_html
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

You can also use your helpers in your views. For example when using HMote,
you could use the above helper like this:

```html
<div class="content">{{ app.markdown("...") }}</div>
```
