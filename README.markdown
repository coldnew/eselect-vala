eselect-vala
============

An eselect module to easily manage what version of valac to use by default if
there are several ones installed in your Gentoo system.

Usage
-----

Use `eselect vala` as regular eselect module, Ex:

	$ eselect vala list
	Available valac versions:
	  [1]   valac-0.10
	  [2]   valac-0.12 *
	$ sudo eselect vala set 1

That will choose 0.10 branch instead of previously active 0.12.

Of course, you can still access any version of `valac` you want by manually
specifying it's version in a command line, Ex:

	$ eselect vala show
	Current valac version:
	  /usr/bin/valac-0.10
	$ valac-0.12 helloworld.vala
	
Authors
-------

Gavrilov Maksim <ulltor@gmail.com>

Copying
-------

This software is distributed under the terms of the GNU General Public License v2.
