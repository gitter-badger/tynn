# Plugins

Another way to extend Tynn is to use the plugin API. A plugin is just a
module which can contain any of the following rules:

- If a `ClassMethods` module is defined, it extends the application class.

- If a `InstanceMethods` module is defined, it's included in the application.

- If a `setup` method is defined, it will be called last. This method can
  be used to configure the plugin.

Here is a complete example:

```ruby
module AppName
  def self.setup(app, app_name: "MyApp")
    settings[:app_name] = app_name
  end

  module ClassMethods
    def app_name
      return settings[:app_name]
    end
  end

  module InstanceMethods
    def app_name
      return self.class.app_name
    end
  end
end
```

To load the plugin use:

```ruby
Tynn.plugin(AppName, app_name: "MyAwesomeApp")
```

Here is the plugin in action:

```ruby
Tynn.app_name # => "MyAwesomeApp"

Tynn.define do
  get do
    res.write(app_name)
  end
end

# GET / => 200 "MyAwesomeApp"
```

[plugin]: /api/Tynn.html#method-c-plugin
