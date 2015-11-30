# Bundler

[Bundler][bundler] is the most popular tool to manage dependencies. To get
started, open a terminal window and run:

```no-highlight
$ gem install bundler
```

Create a `Gemfile` in your project's root directory. You can generate
one with:

```no-highlight
$ bundle init
```

Update the contents of the `Gemfile` with your project dependencies:

```ruby
source "https://rubygems.org"

gem "tynn", "~> 1.0"
```

Install all dependencies with:

```no-highlight
$ bundle install
```

Bundler still installs all the gems globally, so you need to load
your bundled environment before the gems are required.

```ruby
require "bundler/setup"
require "tynn"
```

Check [Bundler's homepage][bundler] for more information.

[bundler]: http://bundler.io/
