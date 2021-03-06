# Ze Emacs

Ze emacs is (my) personal, somewhat modularised, emacs configuration. You're welcome to use it, but it's not intended to be general-purpose, moreover, I don't intend to start yet another Emacs distribution proper. If you're looking for that, there's Prelude, SpaceMacs, Cabbage etc etc etc.

Most module's initialisation functionality are written in a style closely resembling how Prelude initialises its modules.

## What does it do?
It's really just a bunch of modules (living in the modules directory) which can be loaded at will and which, if possible, are written to delay actual initialization work until they are activated, to make opening Emacs a speedy affair.

Having the form `(ze-mod-load "foo")` in one's init.el (.emacs) will look in '~/emacs.d/modules' for a 'ze-foo.el' file.

Each ze-module can have two components, both of which are optional:
* `ze-<modname>/deps` - expected to be a list of symbols, each symbol representing a package which should be fetched from Melpa if it is missing.
* `ze-<modname>/init` - expected to be a function accepting no arguments. This is run once all modules have been loaded in[1].

Finally, `(ze-init)` instructs it all to actually initialise, at which point all dependent packages will be inspected, and if any are missing, the packages will be fetched from Melpa. Once dependencies are taken care of, each module's initialisation function will be called in the order the modules were loaded.


**[1]** Technically, once `ze-init` has been called