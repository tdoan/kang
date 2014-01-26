#!/usr/bin/env ruby

#
# kang.rb - Main executable for GUI interface
#
# ====================================================================
# Copyright (c) 2014 Tony Doan <tdoan@tdoan.com>.  All rights reserved.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution.  The terms
# are also available at http://github.com/tdoan/kang/tree/master/COPYING.
# If newer versions of this license are posted there, you may use a
# newer version instead, at your option.
# ====================================================================
#
$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require "kang/controller"
require "kang/view"
require "kang/data"
require "kang/colors"
require "kang/tags"
require "rubygems"
begin
  require 'gtk2'
rescue LoadError => ex
  $stderr.puts("This is a GUI application that requires the gtk2 gem be installed, which in turn requires that GTK2 be installed.")
  exit(-1)
end
