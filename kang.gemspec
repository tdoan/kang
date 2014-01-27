# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kang/version"
spec = Gem::Specification.new do |spec|
  spec.name = 'kang'
  spec.version = Kang::VERSION
  spec.authors = ['Tony Doan']
  spec.email = 'tdoan@tdoan.com'
  spec.homepage = 'http://github.com/tdoan/kang'
  spec.summary = 'A visual regex debugger'
  spec.description = %{The Ruby Regex Debugger. Put your regex in the top pane, and your match text in the bottom pane. Kang will highlight the match text that matches and show you any match groups you have created down the right hand side.}
  spec.files = Dir['bin/*.rb','lib/*.rb','lib/kang/*.rb','COPYING','History.txt']
  spec.executables = ['kang']
  spec.add_dependency("glib2", "~> 2.1.0")
  spec.add_dependency("atk", "~> 2.1.0")
  spec.add_dependency("gtk2", "~> 2.1.0")
  spec.add_dependency("pango", "~> 2.1.0")
  spec.add_dependency("cairo", "~> 1.12.6")
  spec.add_dependency("gdk_pixbuf2", "~> 2.1.0")
  spec.has_rdoc = false
end
