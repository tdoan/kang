#!/usr/bin/env ruby

#
# kang.rb - Main executable for GUI interface
#
# ====================================================================
# Copyright (c) 2011 Tony Doan <tdoan@tdoan.com>.  All rights reserved.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution.  The terms
# are also available at http://github.com/tdoan/kang/tree/master/COPYING.
# If newer versions of this license are posted there, you may use a
# newer version instead, at your option.
# ====================================================================
#

require 'rubygems'
require 'wx'
include Wx

#!/usr/bin/env ruby

require "wx" # wxruby2
include Wx 

class EventFrame < Wx::Frame

  def initialize()
    super(nil, -1, "Event Frame")
    set_client_size(Wx::Size.new(500,250))

    @top = Wx::SashLayoutWindow.new( self, -1, Wx::DEFAULT_POSITION,Wx::Size.new(150, self.get_size.y))
    @top.set_default_size(Wx::Size.new(150, self.get_size.y))
    @top.set_orientation(Wx::LAYOUT_VERTICAL)
    @top.set_alignment(Wx::LAYOUT_LEFT)
    @top.background_colour = Wx::RED
    @top.set_sash_visible(Wx::SASH_RIGHT, true)
    
    panel = Wx::Panel.new(@top)
    @bottom = Wx::SashLayoutWindow.new( self, -1, Wx::DEFAULT_POSITION,Wx::Size.new(self.get_size.x,100),Wx::SW_3DSASH)
    @bottom.set_default_size(Wx::Size.new(self.get_size.x,100))
    @bottom.set_orientation(Wx::LAYOUT_HORIZONTAL)
    @bottom.set_alignment(Wx::LAYOUT_BOTTOM)
    @bottom.set_sash_visible(Wx::SASH_TOP, true)
    t = Wx::StaticText.new(@bottom,-1, 'this is @bottom')
    #@right  = Wx::SashLayoutWindow.new( self, :size => [200, 30], :style => Wx::NO_BORDER|Wx::SW_3D)
    #@right.default_size = [1000, 300]
    #@right.orientation  = Wx::LAYOUT_VERTICAL
    #@right.alignment    = Wx::LAYOUT_RIGHT
    #@right.set_sash_visible(Wx::SASH_LEFT, true)
    
  #    .default_size = [1000, 300]
  #    .orientation  = Wx::LAYOUT_HORIZONTAL
  #    .alignment    = Wx::LAYOUT_TOP
  #    .background_colour = Wx::RED
  #    .set_sash_visible(Wx::SASH_BOTTOM, true)
  #


    #textsizer = Wx::BoxSizer.new(Wx::VERTICAL)
    #@mainsizer = Wx::GridSizer.new(2,10)
    @text  = Wx::TextCtrl.new(@top,-1,'Regex in here',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE|TE_RICH)
    #@text2 = Wx::TextCtrl.new(@bottom,-1,'Text in here',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE)
    #@grouplist = Wx::ListBox.new(@right, 60, Wx::DEFAULT_POSITION, Wx::DEFAULT_SIZE, ['a','b','c','one','two','three'], Wx::LB_SINGLE)


    #textsizer.add(@text, 1,Wx::GROW|Wx::ALL,2)
    #textsizer.add(@text2,1,Wx::GROW|Wx::ALL,2)
    #mainsizer.add(textsizer,1,Wx::GROW|Wx::ALL,2)
    #mainsizer.add(@grouplist,1,Wx::GROW|Wx::ALL,2)

    #@status = StatusBar.new(self,-1)
    #sizer.add(@status,0,Wx::ALIGN_LEFT,2)

    #self.set_sizer(mainsizer)
    Wx::LayoutAlgorithm.new.layout_frame(self, panel)
  end
end

class Kang < App

  def on_init
    EventFrame.new.show
  end
end


Kang.new.main_loop
