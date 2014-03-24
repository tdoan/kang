#
# view.rb - Main executable for GUI interface
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
  class View
    def initialize(controller,data)
      reg_text=data.regex_string
      match_text=data.match_string
      @controller = controller
      @data = data
      @window = Gtk::Window.new(Gtk::Window::Type::TOPLEVEL)
      @window.set_title  "Kang"
      @window.border_width = 10
      @window.set_size_request(600, 400)
      @window.signal_connect('delete_event') { Gtk.main_quit }

      wintop = Gtk::ScrolledWindow.new
      wintop.set_policy(Gtk::PolicyType::AUTOMATIC, Gtk::PolicyType::ALWAYS)

      winbottom = Gtk::ScrolledWindow.new
      winbottom.set_policy(Gtk::PolicyType::AUTOMATIC,Gtk::PolicyType::ALWAYS)

      winright = Gtk::ScrolledWindow.new
      winright.set_policy(Gtk::PolicyType::AUTOMATIC,Gtk::PolicyType::ALWAYS)
      winright.set_size_request(250,-1)

      @statusbar = Gtk::Statusbar.new
      @statusbar.push(0,"")

      @regview = Gtk::TextView.new
      @regview.buffer.text = reg_text

      @matchview = Gtk::TextView.new
      @matchview.buffer.text = match_text
      @tags = Tags.new(@matchview)

      wintop.add(@regview)
      winbottom.add(@matchview)

      @list_store = Gtk::ListStore.new(String, String)
      treeview = Gtk::TreeView.new(@list_store)
      renderer = Gtk::CellRendererText.new
      column0 = Gtk::TreeViewColumn.new("#",renderer, {:text => 0})
      column1 = Gtk::TreeViewColumn.new("Match",renderer, {:text => 1})
      column1.set_cell_data_func(renderer) do |tvc,cell,model,iter|
        cell.background_gdk = @tags[iter.path.to_str.to_i].background_gdk
      end
      treeview.append_column(column0)
      treeview.append_column(column1)
      treeview.selection.mode = Gtk::SelectionMode::NONE
      winright.add(treeview)

      vpaned = Gtk::Paned.new(:vertical)
      vpaned.add1(wintop)
      vpaned.add2(winbottom)
      vpaned.set_size_request(250,-1)
      hpaned = Gtk::Paned.new(:horizontal)
      hpaned.pack1(vpaned, resize: true, shrink: false)
      hpaned.pack2(winright, resize: false, shrink: false)
      vbox = Gtk::Box.new(:vertical,0)
      vbox.pack_start(hpaned, expand: true, fill: true, padding: 0)
      @multiline = Gtk::CheckButton.new("multiline")
      vbox.pack_start(@multiline, expand: false, fill: false, padding: 0)
      @extended = Gtk::CheckButton.new("extended")
      vbox.pack_start(@extended, expand: false, fill: false, padding: 0)
      @spinbutton = Gtk::SpinButton.new(1, 1, 1)
      @spinbutton.sensitive=false
      vbox.pack_start(@spinbutton, expand: false, fill: false, padding: 0)
      vbox.pack_start(@statusbar, expand: false, fill: false, padding: 0)
      @window.add(vbox)

      @regview.signal_connect("key-release-event") {|view,event| @controller.key_up_reg(view,event,view.buffer.text)}
      @matchview.signal_connect("key-release-event") {|view,event| @controller.key_up_match(view,event,view.buffer.text)}
      @multiline.signal_connect("clicked") {|view,event| @controller.multiline_click(view,event)}
      @extended.signal_connect("clicked") {|view,event| @controller.extended_click(view,event)}
      @spinbutton.signal_connect("value-changed") {|button| @controller.spin_change(button.value.to_i)}
    end

    def start
      @window.show_all
      begin
        Gtk.main
      rescue SystemExit, Interrupt
        exit(0)
      end
    end

    def repaint
      update_status
      update_spin_count
      update_match_groups
      update_tag if @data.match
    end

    private
    def update_tag
      remove_tag
      if @data.match_group_count > 0
        @data.match_group_count.times { |i| paint_tag(i) }
      end
    end

    def paint_tag(group=0)
      if @data.regex_valid? and @data.match? and @data.match_begin(group)
        tag_begin = @data.match_begin(group)
        tag_end   = @data.match_end(group)
        b = @matchview.buffer.get_iter_at(offset: tag_begin)
        e = @matchview.buffer.get_iter_at(offset: tag_end)
        @matchview.buffer.apply_tag(@tags[group],b,e)
      end
    end

    def update_status
      unless @data.regex_valid?
        remove_tag
        message = "Invalid Regex"
      else
        message = "Matched with #{@data.match_group_count} grouping"
        message += "s" if @data.match_group_count > 1
        if @data.match?
          update_tag #(@data.match_begin,@data.match_end)
        else
          remove_tag
          message = "no match"
        end
      end
      @statusbar.pop(0)
      @statusbar.push(0,message)
    end

    def update_match_groups
      @list_store.clear
      if @data.regex_valid?
        @data.matches.each{|m| iter = @list_store.append; iter[0]=m[0];iter[1]=m[1]}
      end
    end

    def remove_tag
      buffer = @matchview.buffer
      bstart = buffer.get_iter_at(offset: 0)
      bend = buffer.get_iter_at(offset: buffer.text.size)
      @matchview.buffer.remove_all_tags(bstart,bend)
    end

    def update_spin_count
      @spinbutton.sensitive = @data.multiline
      if @data.multiline
        @spinbutton.set_range(1, @data.num_lines)
      end
    end

    def toggle_multiline(active)
      update_spin_count
      @spinbutton.sensitive = active
    end
  end
end
