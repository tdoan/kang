#
# offset_data.rb - Main executable for GUI interface
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
  class OffSetMatchData
    def initialize(offset,match_data)
      @offset = offset
      @match_data = match_data
    end

    def begin(i)
      @match_data.begin(i) + @offset
    end

    def end(i)
      @match_data.end(i) + @offset
    end

    def length
      @match_data.length
    end

    def [](x)
      @match_data[x]
    end

    def names
      @match_data.names
    end

    def to_a
      @match_data.to_a
    end
  end
end
