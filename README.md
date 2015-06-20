MiniRake
========

*DISCLAIMER*
------------

This is a simple project meant to learn about the ruby programming language. I did not intend this to be used, that's why I didn't publish it as a Ruby Gem. It's merely a bit of programming fun.

Introduction
------------

I tried/am trying to reproduce a simple implementation of the well-known rake CLI by the late Jim Weirich.

If you want to try it
---------------------

Simply clone this repo and link the 'binary' (executable) `bin/minirake`
somewhere your $PATH picks up. Example:

`$ ln -s /path/to/this/repo/bin/minirake /usr/local/bin/minirake`

Then you can run

`$ minirake`

From any directory that has a *.minirake file.
