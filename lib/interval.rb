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
    res = [].tap do |out|
      tmp = b.sort { |l, r| l.start == r.start ? l.end <=> r.end : l.start <=> r.start }
      rej = []
      idx = 0
      while idx <= tmp.size - x
        c = tmp[idx]
        rej << c if tmp[idx+1..idx+x-1].all? { |i| i == c }
        idx += 1 until (tmp[idx] != c || idx > tmp.size - x)
      end
      rej.compact!
      rej.uniq!(&:to_s)
      rej.each do |i|
        out << a - i
      end
    end.flatten
    res.one? ? res.first : res
  end

  def self.p2(intervals)
    [].tap do |out|
      sorted = intervals.sort do |l, r|
        return 0 if l == r
        cl, cr = l.start == r.start ? [l.end, r.end] : [l.start, r.start]
        time_string_compare(:<, cl, cr) ? -1 : 1
      end
      sorted.each_with_index do |int, idx|
        p2_prepare([int], sorted[idx+1..-1], out) unless out.any? { |o| o.include? int }
      end
    end.uniq.reject { |x| x.empty? }
  end

  def self.p2_prepare(tmp, intervals, out)
    return if out.any? { |o| tmp.all? { |t| o.include? t } } # can safely prune here
    idx = 0
    while idx < intervals.size
      int = intervals[idx]
      temp_idx = idx
      new_tmp = tmp
      last_time = tmp.last.end
      series = []
      while temp_idx < intervals.size
        c = intervals[temp_idx]
        break unless time_string_compare(:<=, last_time, c.start)
        series << c
        last_time = c.end
        temp_idx += 1
      end
      if temp_idx > idx
        new_tmp = tmp + series
        next_intervals = intervals[temp_idx..-1]
        if next_intervals.any?
          p2_prepare(new_tmp, next_intervals, out) 
        elsif out.none? { |o| new_tmp.all? { |t| o.include? t } }
          out.concat [new_tmp]
        end
      end
      idx = [temp_idx, idx + 1].max
    end
    out.concat [tmp] unless out.any? { |o| tmp.all? { |t| o.include? t } }
  end
end
