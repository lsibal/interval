class Interval
  attr_accessor :start, :end

  def initialize(istart = 0, iend = 0)
    fail "Start and End times should be numeric" unless istart.is_a?(Fixnum) && iend.is_a?(Fixnum)
    fail "Invalid interval" if istart > iend
    @start = istart
    @end = iend
  end

  def contains?(interval)
    return false unless interval.is_a?(Interval)
    start <= interval.start && self.end >= interval.end
  end

  def to_s
    "#{self.start}-#{self.end}"
  end

  def -(i)
    return nil if self == i
    i.start = self.start if i.start < self.start
    i.end = self.end if i.end > self.end
    return Interval.new(i.end + 1, self.end) if (self.start == i.start)
    return Interval.new(self.start, i.start - 1) if (self.end == i.end)
    return [Interval.new(self.start, i.start - 1), Interval.new(i.end + 1, self.end)]
  end

  def ==(i)
    (self.start == i.start) && (self.end == i.end)
  end

  def self.p1(a, b, x)
    res = [].tap { |out| ((b.reject { |i| b.count(i) < x }).compact.uniq { |i| i.to_s }).each { |i| out << a - i } }.flatten
    res.one? ? res.first : res
  end
end
