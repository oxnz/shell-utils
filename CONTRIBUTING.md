Guide Lines
-----------

1. the plugin manager should keep in one top directory
2. install script should be robust and most compatible
3. the startup should contain debug functionability such as list the loaded functions and libraries
4. should keep effeciency in mind, so compile needed
5. code should be documented, generate help file from source file
6. interface skel help func to system access, such as help in bash and run-help in zsh
7. cause there\'s many perl script in /bin and /usr/bin, so the skel implemented in perl, if needed, can be rewrite in C/C++

Bug Report
----------

If you\'re reporting a bug, please open an issue.

Pull Request
------------

Pull requests should be targeted at Shell-utils' master branch. Before pushing to your Github repo and issuing the pull request, please do two things:

1. Rebase your local changes against the master branch. Resolve any conflicts that arise.
2. Run the full test suite with the make check command. You're not off the hook even if you just stick to documentation; code examples in the docs are tested as well! Although for simple wording or grammar fixes, this is probably unnecessary.

Normally, all pull requests must include regression tests (see Note-testsuite) that test your change. Occasionally, a change will be very difficult to test for. In those cases, please include a note in your commit message explaining why.

In the licensing header at the beginning of any files you change, please make sure the listed date range includes the current year. For example, if it's 2014, and you change a Shell-utils file that was created in 2010, it should begin:

> Copyright 2010-2014 The Shell-utils Project Developers.

