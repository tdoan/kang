KANG - The Ruby Regex Debugger
====

[Homepage](http://github.com/tdoan/kang/)

DESCRIPTION
-----------

This is a cross-platform GUI application. To run it you'll need Ruby (1.8.7, 1.9.2, 1.9.3, and 2.0.0 have been tested) and the gtk2 gem (tested through 1.2.2). Ruby 2.0 requires gtk >= 1.2.5.

### SYNOPSIS:

*  `gem install kang` (see INSTALL below)
*  kang

### REQUIREMENTS:

* ruby
* rubygems
* gtk2 gem
* gtk2 libraries

### INSTALL:

#### Linux:
First you will need gtk2, which is more than likely already installed if you are running X Windows. Unfortunately chances are you'll have the libraries but not the *dev* packages with the header files. Here are the *dev* packages that I had to add on Ubuntu 11/12:

* libglib2.0-dev
* libatk1.0-dev
* libcairo2-dev
* libpango1.0-dev
* libgdk-pixbuf2.0-dev

So use apt/rpm/etc. to install the dev packages. Then run:

`gem install kang`

This will install all the gem dependencies.

#### Mac OS X:
`brew install gtk+`

`gem install kang`

#### Windows:
The Windows GTK gems include all the binary bits of GTK ready to go for Windows. Just run:

`gem install kang`

### LICENSE:

Copyright (c) 2014 Tony Doan <tdoan@tdoan.com>.  All rights reserved.
This software is licensed as described in the file COPYING, which
you should have received as part of this distribution.  The terms
are also available at http://github.com/tdoan/kang/tree/master/COPYING.
If newer versions of this license are posted there, you may use a
newer version instead, at your option.
