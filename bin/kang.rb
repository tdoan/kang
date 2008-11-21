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
    set_client_size(Wx::Size.new(640,480))
    sizer = Wx::BoxSizer.new(Wx::VERTICAL)
    @text  = Wx::TextCtrl.new(self,-1,'Regex in here',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE|TE_RICH)
    @text2 = Wx::TextCtrl.new(self,-1,'Text in here',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE)
    sizer.add(@text, 1,Wx::GROW|Wx::ALL,2)
    sizer.add(@text2,1,Wx::GROW|Wx::ALL,2)
    @status = StatusBar.new(self,-1)
    sizer.add(@status,0,Wx::ALIGN_LEFT,2)
    self.set_sizer(sizer)
    evt_text(@text.get_id){|event| text_change(event)}
    evt_text(@text2.get_id){|event| text_change(event)}
  end

  def set_status(text)
    @status.pushd_status_text(text)
  end

  def text_change(event)
    ip = @text2.get_insertion_point
    size = @text2.get_value.size
    begin 
      r = Regexp.new(@text.get_value)
    rescue
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
      else
        ret = @text2.set_style(0,size,@normal)
        @text2.append_text("")
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
