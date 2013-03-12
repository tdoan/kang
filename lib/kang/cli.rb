#
# cli.rb - Main executable for GUI interface
#
# ====================================================================
# Copyright (c) 2013 Tony Doan <tdoan@tdoan.com>.  All rights reserved.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution.  The terms
# are also available at http://github.com/tdoan/kang/tree/master/COPYING.
# If newer versions of this license are posted there, you may use a
# newer version instead, at your option.
# ====================================================================
#

module Kang
  class CLI
    def self.execute(stdout, arguments=[])
      Kang::Controller.new
    end
  end
end
