# Managing Dependencies

In every web application, there are common tasks that you need to perform.
Libraries are useful for not reinventing the wheel, and in Ruby they are
often referred to as *gems*.

Ruby uses [Rubygems](https://rubygems.org/) to distribute them and to
ease the installation. Installing Tynn was as easy as typing
`gem install tynn` in the command line.

Even though Rubygems is useful when installing gems, it has its
limitations. Unfortunately, it installs all gems globally. This means
that if you have different versions of a gem installed, you have to
make sure that you require the right version for your project.

We need a way to keep track of the dependencies and install the right version
of each one. This is where tools like [gs](https://github.com/soveran/gs) and
[dep](https://github.com/cyx/dep) come to the rescue.

## gs

With gs you can create a *gemset* for each project. A gemset is an
isolated space to install gems. By providing each project with its own
gemset, you can be sure that the right version of a gem is loaded.

To install gs, do:

```no-highlight
$ gem install gs
```

Creating a new gemset is as easy as typing:

```no-highlight
$ gs init
```

This command creates a directory `.gs` and starts a shell session. In this
session, all gems will be installed locally in the `.gs` folder.

## dep

Now that we created a gemset, you can use `dep` to keep track of the project
dependencies.

dep uses a `.gems` file to list the required gems with their version
number. This file will be created automatically the first time you add a
gem to the list.

To add tynn to this list, use:

```no-highlight
$ dep add tynn
```

This fetches the latest version of the gem and adds it to yours `.gems` file.

```no-highlight
$ cat .gems
tynn -v 1.0.0
```

To install the listed gems in the `.gs` folder, do:

```no-highlight
$ dep install
```

To check that they're installed, use:

```no-highlight
$ dep
dep: all cool
```

If all is cool, you're good to go!

