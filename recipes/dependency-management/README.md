# Dependency Management

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
