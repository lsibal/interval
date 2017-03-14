class Interval
  attr_accessor :start, :end

  def initialize(istart = 0, iend = 0, special_type = :none)
    # fail "Start and End times should be numeric" unless istart.is_a?(Fixnum) && iend.is_a?(Fixnum)
    # fail "Invalid interval" if istart > iend
    @start = istart
    @end = iend
    @type = special_type
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
    i.start = [i.start, self.start].max
    i.end = [self.end, i.end].min
    return Interval.new(i.end + 1, self.end) if (self.start == i.start)
    return Interval.new(self.start, i.start - 1) if (self.end == i.end)
    return [Interval.new(self.start, i.start - 1), Interval.new(i.end + 1, self.end)]
  end

  def ==(i)
    (self.start == i.start) && (self.end == i.end)
  end

  def self.time_string_compare(op, left, right)
    lhour, lmin = left.split(':').map(&:to_i)
    rhour, rmin = right.split(':').map(&:to_i)

    lhour == rhour ? lmin.send(op, rmin) : lhour.send(op, rhour)
  end

  def self.p1(a, b, x)
    res = [].tap { |out| ((b.reject { |i| b.count(i) < x }).compact.uniq(&:to_s)).each { |i| out << a - i } }.flatten
    res.one? ? res.first : res
  end

  def self.p2(intervals)
    [].tap do |out|
      intervals.sort { |a, b| a.start <=> b.start }.each_with_index do |int, idx|
        p2_prepare([], intervals[idx..-1], out)
      end
    end.uniq.reject { |x| x.empty? }
  end

  def self.p2_prepare(tmp, intervals, out)
    intervals.each_with_index do |int, idx|
      if tmp.empty? || time_string_compare(:<=, tmp.last.end, int.start)
        p2_prepare(tmp + [int], intervals[idx+1..-1], out)
      end
    end
    out.concat([tmp]) unless out.any? { |o| tmp.all? { |t| o.include? t } }
  end
end
