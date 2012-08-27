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
