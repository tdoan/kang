#
# controller.rb - Main executable for GUI interface
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

module Kang
  class Controller
    def initialize
      reg_text = "RegEx here"
      match_text = "Match Text Here"
      @data = Data.new(reg_text,match_text)
      @view = View.new(self,@data)
      @view.start
    end

    def key_up_match(view,event,match_string)
      #@view.update_status("")
      @data.match_string = match_string
      #key_up
      @view.repaint
    end

    def key_up_reg(view,event,text)
      #@view.update_status("")
      @data.regex_string = text
      #key_up
      @view.repaint
    end

    def multiline_click(view,event)
      @data.multiline=view.active?
      #@view.toggle_multiline(view.active?)
      @view.repaint
    end

    def spin_change(value)
      @data.line_number = value
      #@view.update_tag
      @view.repaint
    end
  end
end
