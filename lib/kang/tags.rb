#
# tags.rb - GTK tags for colors library
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
  class Tags
    def initialize(view)
      @view=view
      @colors = Colors.new(5,range: 65545)
      @tags = {}
    end

    def[](i)
      tag = nil
      begin
        tag_name = "color#{i}"
        tag =  @tags.fetch(tag_name)
      rescue KeyError
        c = @colors[i]
        color = Gdk::Color.new(*c)
        tag = Gtk::TextTag.new(tag_name)
        tag.foreground='black'
        tag.background_gdk=color
        @tags[tag_name] = tag
        @view.buffer.tag_table.add(tag)
      end
      tag
    end
  end
end
