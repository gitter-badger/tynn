# Middlewares

Tynn runs on [Rack](https://github.com/rack/rack). Therefore it is possible to use Rack middlewares in Tynn. This is how you add a middleware (for example `YourMiddleware`) to your app:

```ruby
Tynn.use(YourMiddleware)
```

You can use any rack middleware to your app, it is not specific to Tynn. You can find a list of Rack middlewares [here](https://github.com/rack/rack/wiki/list-of-middleware).

## Example Usage: Allow method override

HTML Forms currently only support GET and POST requests. You may want to have a form that performs other actions such as PUT though. The usual solution to simulate a PUT is using a POST form, but adding a hidden input field with the name `_method` and the value `put`. For example:

```html
<form method="post" action="/update">
  <input type="hidden" name="_method" value="put">
  ...
</form>
```

In Tynn this would however trigger the `post` action, as it is send as a post request from your browser. With a middleware we can now rewrite this request and change the method to be `PUT`. There is a middleware called [Rack::MethodOverride](https://github.com/rack/rack/blob/master/lib/rack/method_override.rb) included in Rack that does exactly that, so let's add it to our Tynn app:

```ruby
Tynn.use(Rack::MethodOverride)
```

Now this will trigger the `put` action in your app. It will also work for other missing methods like `DELETE`. Note that you do not need to add any new dependencies to your application as it is included in Rack already.
