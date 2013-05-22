class Colors
  def initialize(initial_size=nil, options={})
    valid_options = [:saturation,:value,:starting_hue,:range]
    default_options = {saturation:0.3, value:0.8, :starting_hue=>rand, :range=>256}
    options.keys.each do |k|
      raise ArgumentError, "Unknown option: #{k}" unless valid_options.include? k
    end
    default_options.merge!(options)
    [:saturation, :value, :starting_hue].each do |k|
      raise ArgumentError, "The option \"#{k.to_s}\" must be between 0 and 1" if((default_options[k] > 1) or (default_options[k] < 0))
    end
    @golden_ratio_conjugate = 0.618033988749895
    @h = default_options[:starting_hue]
    @saturation = default_options[:saturation]
    @value = default_options[:value]
    @colors = []
    @range = default_options[:range]
    unless initial_size.nil?
      initial_size.times do
        self.next
      end
    end
  end

  def self.to_hex(rgb)
    rgb.collect{|n| n.to_s(16).upcase}.join
  end

  def hsv_to_rgb(h, s, v)
    h_i = (h*6).to_i
    f = h*6 - h_i
    p = v * (1 - s)
    q = v * (1 - f*s)
    t = v * (1 - (1 - f) * s)
    r, g, b = v, t, p if h_i==0
    r, g, b = q, v, p if h_i==1
    r, g, b = p, v, t if h_i==2
    r, g, b = p, q, v if h_i==3
    r, g, b = t, p, v if h_i==4
    r, g, b = v, p, q if h_i==5
    [(r*@range).to_i, (g*@range).to_i, (b*@range).to_i]
  end

  def each(&block)
    @colors.each(&block)
  end

  def [](i)
    if @colors.size-1 < i
      diff  = i - @colors.size + 1
      (diff).times do
        self.next
      end
    end
    @colors[i]
  end

  def next
    @h += @golden_ratio_conjugate
    @h %= 1
    c = hsv_to_rgb(@h, @saturation, @value)
    @colors << c
    c
  end
end
