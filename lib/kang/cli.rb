module Kang
  class CLI
    def self.execute(stdout, arguments=[])
      Kang::Controller.new
    end
  end
end