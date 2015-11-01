# gs + dep

With [gs][gs] you can create a gemset for each project. A gemset is an
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

Now that we created a gemset, you can use [dep][dep] to keep track of the
project dependencies. dep uses a `.gems` file to list the required gems with
their version number. This file will be created automatically the first time
you add a gem to the list.

To add tynn to this list, use:

```no-highlight
$ dep add tynn
```

This fetches the latest version of the gem and adds it to yours `.gems` file.

```no-highlight
$ cat .gems
tynn -v 1.2.0
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

[dep]: https://github.com/cyx/dep
[gs]: https://github.com/soveran/gs
