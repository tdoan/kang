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
