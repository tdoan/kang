#!/usr/bin/env ruby

#
# kang.rb - Main executable for GUI interface
#
# ====================================================================
# Copyright (c) 2008 Tony Doan <tdoan@tdoan.com>.  All rights reserved.
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
  def message(text, title)
    m = Wx::MessageDialog.new(self, text, title, Wx::OK | Wx::ICON_INFORMATION)
    m.show_modal()
  end

  def initialize()
    @highlight = Wx::TextAttr.new(Wx::GREEN, Wx::Colour.new(255, 255, 0) )
    @normal    = Wx::TextAttr.new(Wx::BLACK, Wx::WHITE) #, Wx::Colour.new(255, 255, 0) )

    super(nil, -1, "Kang")
    #set_client_size(Wx::Size.new(640,480))
    #sizer = Wx::BoxSizer.new(Wx::VERTICAL)
    #supersizer = Wx::BoxSizer.new(Wx::VERTICAL)
    #panel = Wx::Panel.new(self)
    
    @topwin1 =  Wx::SashLayoutWindow.new( self, :size => [400, 400], :style => Wx::NO_BORDER|Wx::SW_3D )
    @topwin1.default_size = [600, 600]
    @topwin1.orientation  = Wx::LAYOUT_HORIZONTAL
    @topwin1.alignment    = Wx::LAYOUT_TOP
    @topwin1.background_colour = Wx::BLUE
    @topwin1.set_sash_visible(Wx::SASH_RIGHT, true)
    @topwin1.extra_border_size = 10
    @text  = Wx::TextCtrl.new(@topwin1,-1,'(Regex)? (in) (here)',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE|TE_RICH)

    @bottomwin1 =  Wx::SashLayoutWindow.new( self, :size => [200, 30], :style => Wx::NO_BORDER|Wx::SW_3D )
    @bottomwin1.default_size = [600, 400]
    @bottomwin1.orientation  = Wx::LAYOUT_HORIZONTAL
    @bottomwin1.alignment    = Wx::LAYOUT_BOTTOM
    @bottomwin1.background_colour = Wx::RED
    @bottomwin1.set_sash_visible(Wx::SASH_LEFT, true)
    @bottomwin1.extra_border_size = 10
    @text2 = Wx::TextCtrl.new(@bottomwin1,-1,'Text in here',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE)
    
    @rightwin1 =  Wx::SashLayoutWindow.new( self, :size => [200, 30], :style => Wx::NO_BORDER|Wx::SW_3D )
    @rightwin1.default_size = [400, 400]
    @rightwin1.orientation  = Wx::LAYOUT_VERTICAL
    @rightwin1.alignment    = Wx::LAYOUT_RIGHT
    @rightwin1.background_colour = Wx::GREEN
    @rightwin1.set_sash_visible(Wx::SASH_LEFT, true)
    @rightwin1.extra_border_size = 10
    
    @list = Wx::ListCtrl.new(@rightwin1,-1,Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::LC_REPORT)
    @list.insert_column(0,"Group Num",Wx::LIST_FORMAT_RIGHT, -1)
    @list.set_column_width(0,85)
    @list.insert_column(1,"Match Data",Wx::LIST_FORMAT_LEFT, -1)
    @list.set_column_width(1,180)
    @status = StatusBar.new(self,-1)
    #supersizer.add(panel,1,Wx::EXPAND)
    #supersizer.add(@status)
    #self.set_sizer(supersizer)
    evt_text(@text.get_id){|event| text_change(event)}
    evt_text(@text2.get_id){|event| text_change(event)}
    text_change(nil)
  end

  def set_status(text)
    @status.set_status_text(text)
  end

  def text_change(event)
    ip = @text2.get_insertion_point
    size = @text2.get_value.size
    begin 
      r = Regexp.new(@text.get_value)
      set_status("")
    rescue
      set_status("Invalid Regex")
      @list.delete_all_items
    end
    unless r.nil?
      md = r.match(@text2.get_value)
      unless md.nil?
        b = md.begin(0)
        e = md.end(0)
        ret= @text2.set_style(0,size,@normal)
        @text2.append_text("")
        @text2.set_style(b,e,@highlight)
        @text2.append_text("")
        @list.delete_all_items
        md.to_a[1..-1].each_with_index do |s,i|
          @list.insert_item(i,"#{i+1}")
          @list.set_item(i,1,s) unless s.nil?
        end
      else
        ret = @text2.set_style(0,size,@normal)
        @text2.append_text("")
        @list.delete_all_items
      end
    else
      ret = @text2.set_style(0,size,@normal)
      @text2.append_text("")
    end
    @text2.set_insertion_point(ip)
  end
end

class Kang < App

  def on_init
    EventFrame.new.show
  end
end


Kang.new.main_loop
