module Kang
  class CLI
    def self.execute(stdout, arguments=[])
      Kang.new.main_loop
    end
  end
end