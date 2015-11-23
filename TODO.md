TODO
====

emergency
---------

1. impl plugins manage system

	* supported options:

		1. enable

			add or uncomment the `su:use` stmt

		2. disable

			comment out the `su:use` stmt

		3. add new

			1. write the plugin
			2. add the `su:use` to load, or `su::reload` to refresh
			3. create a pull request if you would like to share it

		4. remove
		5. status(list all the loaded plugins)
		6. info(display the info related to the speicified plugin)
		7. search

2. unify init and finalize proc hook mechanism

	1. every script file contains an `init' and 'finalize' func

3. unify the func and variable names

	1. shell-utils specific function names are prefixed by 'su::'
	2. shell-utils specific variable names are prefixed by 'su__'

4. add conditional aliaes
5. specify the file load process

	1. load core
	2. load opt
	3. load ext
	4. load plugins
	5. do init
	6. do finalize

6. specify platform-dependent configuration load time

	1. load common func first
	2. load shell-specific
	3. load platform-specific

7. plugins

	1. enable (load, unload, reload)
	2. disable

8. dependency resolv

function `su:dep` to test if the dependency was loaded, if not, `su::use` will do the dirty job to load the dependcy, otherwise just continue

9. debug

	__su__verbose__
	__su__debug__
	su::log
	su::err
	su::errx
	su::warn

10. make all things rock solid

	make them ready for production env use

11. su::def to print the function definition

cadidate
--------

/bin/mv will generate dangling link in the below case:
	mkdir -p a/b
	cd a/b
	touch a
	ln -s a b
	mv b ../
then b is a dangling link, fix this by wrapper the mv up with function:
mv() {
	if [ -L b ]; then
		ln -s "$(readlink -e "${src}")" "${dst}"
	else
		command mv "${src}" "${dst}"
	fi
}

candidate
---------

define a new language ext-shell:
	rewrite script like this:

		function hello() argc>=2,argv=(int,str)
		begin
			echo "hello $argv[1].upper $argv[2].lower"
		end


some other functions

	archive() {
		local cmd
		case "$fmt" in
			rar)
				rar $@
				;;
			tar.gz)
				tar cvzf $@
				;;
			tar.xz)
				tar zxjf $@
				;;
			tar.bz|tar.bz2)
				;;
			zip)
				zip
				;;
		esac
	}

	#use crontab to schedule things
	todo() {:;}
	function remind() {
	}
