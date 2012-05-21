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
$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

begin
  require 'gtk2'
rescue LoadError => ex
  $stderr.puts("This is a GUI application that requires the gtk2 gem be installed, which in turn requires that GTK2 be installed.")
  exit(-1)
end

module Kang
  class Data
    def initialize(reg_text="",match_text="")
      update_regexp(reg_text)
      update_match_string(match_text)
    end

    def update_match_string(match_string)
      @match_string = match_string
      update_match
    end

    def update_match
      if @re
        @match = @re.match(@match_string)
      else
        @match = nil
      end
    end

    def match_group_count
      if @match
        @match.length
      else
        nil
      end
    end

    def update_regexp(re_string)
      begin
        @re = Regexp.new(re_string)
      rescue RegexpError
        @re = nil
      end
      update_match
    end

    def regexp_valid?
      @re.nil? ? false : true
    end

    def match?
      @match ? true : false
    end

    def match_begin
      if @match
        @match.begin(0)
      else
        nil
      end
    end

    def match_end
      if @match
        @match.end(0)
      else
        nil
      end
    end

    def matches
      if @match and (@match.length > 1)
        if @match.names and @match.names.size>0
          names = @match.names.unshift("0")
        else
          names = Range.new(0,@match.length-1).to_a.collect{|o| o.to_s}
        end
        return names.zip(@match.to_a)
      else
        []
      end
    end
  end

  class Controller
    def initialize
      reg_text = "RegExp here"
      match_text = "Match Text Here"
      @view = View.new(self,reg_text,match_text)
      @data = Data.new(reg_text,match_text)
      @view.start
    end

    def key_up_match(view,event,match_string)
      @view.update_status("")
      @data.update_match_string(match_string)
      key_up
    end

    def key_up_reg(view,event,text)
      @view.update_status("")
      @data.update_regexp(text)
      key_up
    end

    private
    def key_up
      unless @data.regexp_valid?
        @view.remove_tag
        @view.update_status("Invalid Regexp")
      else
        count = @data.match_group_count ? @data.match_group_count : "no"
        message = "Matched with #{@data.match_group_count} grouping"
        message += "s" if @data.match_group_count and @data.match_group_count > 1
        @view.update_status(message)
        if @data.match?
          @view.update_tag(@data.match_begin,@data.match_end)
        else
          @view.remove_tag
          @view.update_status("no match")
        end
      end
      @view.update_match_groups(@data.matches)
    end
  end

  class View
    def initialize(controller,reg_text="",match_text="")
      @controller = controller
      @window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
      @window.set_title  "Kang"
      @window.border_width = 10
      @window.set_size_request(600, 400)
      @window.signal_connect('delete_event') { Gtk.main_quit }

      wintop = Gtk::ScrolledWindow.new
      wintop.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)

      winbottom = Gtk::ScrolledWindow.new
      winbottom.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)

      @statusbar = Gtk::Statusbar.new
      @statusbar.push(0,"")

      @regview = Gtk::TextView.new
      @regview.buffer.text = reg_text

      @matchview = Gtk::TextView.new
      @matchview.buffer.text = match_text

      @matchview.buffer.create_tag("colors",{ "foreground" => "green", "background" => "gray" })

      wintop.add(@regview)
      winbottom.add(@matchview)

      @list_store = Gtk::ListStore.new(String, String)
      treeview = Gtk::TreeView.new(@list_store)
      column0 = Gtk::TreeViewColumn.new("Match",Gtk::CellRendererText.new, {:text => 0})
      column1 = Gtk::TreeViewColumn.new("Match",Gtk::CellRendererText.new, {:text => 1})
      treeview.append_column(column0)
      treeview.append_column(column1)
      treeview.selection.mode = Gtk::SELECTION_NONE

      vpaned = Gtk::VPaned.new
      vpaned.add1(wintop)
      vpaned.add2(winbottom)
      vpaned.set_size_request(400,400)
      hpaned = Gtk::HPaned.new
      hpaned.add1(vpaned)
      hpaned.add2(treeview)
      vbox = Gtk::VBox.new(false,0)
      vbox.pack_start(hpaned,true,true,0)
      vbox.pack_start(@statusbar,false,false,0)
      @window.add(vbox)

      @regview.signal_connect("key-release-event") {|view,event| @controller.key_up_reg(view,event,view.buffer.text)}
      @matchview.signal_connect("key-release-event") {|view,event| @controller.key_up_match(view,event,view.buffer.text)}
    end

    def start
      @window.show_all
      begin
        Gtk.main
      rescue SystemExit, Interrupt
        exit(0)
      end
    end

    def update_tag(tag_begin,tag_end)
      remove_tag
      b = @matchview.buffer.get_iter_at_offset(tag_begin)
      e = @matchview.buffer.get_iter_at_offset(tag_end)
      @matchview.buffer.apply_tag("colors",b,e)
    end

    def update_status(message)
      @statusbar.pop(0)
      @statusbar.push(0,message)
    end

    def update_match_groups(matches)
      @list_store.clear
      matches.each{|m| iter = @list_store.append; iter[0]=m[0];iter[1]=m[1]}
    end

    def remove_tag
      buffer = @matchview.buffer
      bstart = buffer.get_iter_at_offset(0)
      bend = buffer.get_iter_at_offset(buffer.text.size)
      @matchview.buffer.remove_tag("colors",bstart,bend)
    end
  end
end
