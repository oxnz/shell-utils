shell-utils
===========

```
         __         ____            __  _ __    
   _____/ /_  ___  / / /     __  __/ /_(_) /____
  / ___/ __ \/ _ \/ / /_____/ / / / __/ / / ___/
 (__  ) / / /  __/ / /_____/ /_/ / /_/ / (__  ) 
/____/_/ /_/\___/_/_/      \__,_/\__/_/_/____/  
```

[![Build Status](https://travis-ci.org/oxnz/shell-utils.svg?branch=master)](https://travis-ci.org/oxnz/shell-utils) [![Join the chat at https://gitter.im/oxnz/shell-utils](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/oxnz/shell-utils?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Introduction
------------

This project is intend to serve you a bunch of convenient stuff include alias,
functions, etc., which makes life easier.

Install
-------

### automatic

Open terminal and type:

	curl -L https://raw.githubusercontent.com/oxnz/shell-utils/master/tool/install | sh

or

	wget https://raw.githubusercontent.com/oxnz/shell-utils/master/tool/install -O - | sh

and this will append the source command in your .bashrc and .zshrc, then create
the `.shell` directory under your $HOME.

To specify another directory instead of the default ~/.shell, you need define the DESTDIR variable like this:

	wget https://raw.githubusercontent.com/oxnz/shell-utils/master/tool/install -O - | DESTDIR=path-to-install sh

### manual

1. Clone the repository:

`git clone https://github.com/oxnz/shell-utils.git ~/.shell`

2. Source bootstrap file in the dot-shrc file:

```
echo '. ~/.shell/bootstrap.sh' >> ~/.bashrc
echo '. ~/.shell/bootstrap.sh' >> ~/.zshrc
```

3. Already done, just open a new terminal and testing the amazing stuff.

For more information, refer to the [install manual](./tool/install.md)

Customize
---------

If you want to override any of the default behaviors, just add the stuff in the custom/ directory.

Update
------

There's two strategies for update:

* manually:
```
	skel update
```
* automatically:

`skel set autoupdate=true`

If you don't want check upgrade automatically:

`skel set autoupdate=false`

Uninstall
---------

`skel destroy`

Infrastructure
--------------

```
~/.shell
	|___ rc/		# source entry directory, this directory is generated
	|___ skel/		# shell-utils manager
	|___ doc/		# documentation
	|___ bin/		# this path will add to the PATH variable
	|___ src/		# source code for libs and plugins
	|___ lib/		# library stuff used by plugin manager and dependencies
	|___ opt/		# plugins would be here
	|___ var/		# data files
	|___ core/		# source this directory unconditionally
	|___ ext/		# extension utils
	|___ tool/		# tools used for generate docs, check codes, etc.
	|___ test/		# test suits
	|___ misc/		# misc
	|___ custom/	# customize script
	|___ .git/		# git directory
	|___ .gitignore	# ignore the .git and custom directory
```

For more details, please see doc/infrastructure

Notes
-----

This section is intend leave blank

Contribute
----------

If you have ideas on how to make the configuration easier to maintain (and faster), don’t hesitate to fork and send pull requests!

Any impovement is welcome. For more details, please refer to the CONTRIBUTING.md.

License
-------

Shell-utils is distributed under the terms of the MIT license.

See LICENSE and COPYRIGHT for details
