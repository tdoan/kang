#!/usr/bin/env ruby

#KANG - The Ruby Regexp Debugger
# Copyright
# Tony Doan <tdoan@tdoan.com>
# 2008-10-16

require 'wx'
include Wx

#!/usr/bin/env ruby

require "wx" # wxruby2
include Wx 

class EventFrame < Wx::Frame
  def on_key(event)
    message("Key pressed", "Key Event: #{event.get_key_code}")
  end
  
  def message(text, title)
    m = Wx::MessageDialog.new(self, text, title, Wx::OK | Wx::ICON_INFORMATION)
    m.show_modal()
  end
  
  def initialize()
    ta = Wx::TextAttr.new(Wx::GREEN, Wx::Colour.new(255, 255, 0) )
    
    super(nil, -1, "Event Frame")
    set_client_size(Wx::Size.new(640,480))
    sizer = Wx::BoxSizer.new(Wx::VERTICAL)
    text  = Wx::TextCtrl.new(self,-1,'Regex in here',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE)
    text2 = Wx::TextCtrl.new(self,-1,'Text in here',Wx::DEFAULT_POSITION,Wx::DEFAULT_SIZE,Wx::TE_MULTILINE)
    sizer.add(text, 1,Wx::GROW|Wx::ALL,2)
    sizer.add(text2,1,Wx::GROW|Wx::ALL,2)
    button = Wx::Button.new(self,-1,'Click on this')
    sizer.add(button,0,Wx::ALIGN_CENTER,10)
    @status = StatusBar.new(self,-1)
    sizer.add(@status,0,Wx::ALIGN_LEFT,2)
    self.set_sizer(sizer)
    evt_char {|event| on_key(event)}
    evt_button(button.get_id) do
      puts "Top: #{text.get_value}"
      puts "Bot: #{text2.get_value}"
      puts
    end
    evt_text(text.get_id) do | event |
      begin 
        r = Regexp.new(text.get_value)
      rescue
      end
      unless r.nil?
        puts "Valid Regex!"
        md = r.match(text2.get_value)
        unless md.nil?
          b = md.begin(0)
          e = md.end(0)
          puts b
          puts e
          puts text2.get_value[b..e-1] 
          ret = text2.set_style(b,e,ta)
          puts "Ret: #{ret}"
        end
      end
    end
  end

  def set_status(text)
    @status.pushd_status_text(text)
  end
end

class Kang < App
  
  def on_init
    EventFrame.new.show
  end
end


Kang.new.main_loop
