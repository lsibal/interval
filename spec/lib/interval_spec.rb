# frozen_string_literal: true

require 'spec_helper'
require 'interval'
require 'benchmark'

describe Interval do

  def gen_intervals(min, max, n)
    rnd = Random.new
    xs = []
    n.times do
      _start = rnd.rand(min..max)
      _end = rnd.rand(_start..max)
      xs << [_start, _end]
    end
    xs
  end

  def gen_string_times(min, max, n)
    xs = gen_intervals(min, max, n)
    xs.map do |_start, _end|
      sh = _start / 60
      sm = _start % 60
      s = "#{sh}:#{'%02d' % (sm)}"
      eh = _end / 60
      em = _end % 60
      e = "#{eh}:#{'%02d' % (em)}"
      Interval.new(s, e)
    end
  end

  describe "Problem #1" do
    subject { Interval.p1(a, b, x) }

    context 'Test #1' do
      let(:a) { Interval.new(1,100) }
      let(:b) { [Interval.new(1,50),
                 Interval.new(1,50),
                 Interval.new(1,50),
                 Interval.new(70,100),
                 Interval.new(80,90)] }
      let(:x) { 3 }

      it { should eq Interval.new(51, 100) }
    end

    context 'Test #2' do
      let(:a) { Interval.new(1,100) }
      let(:b) { [Interval.new(51,100),
                 Interval.new(51,100),
                 Interval.new(80,100),
                 Interval.new(80,100),
                 Interval.new(80,90)] }
      let(:x) { 2 }

      it { should include Interval.new(1,50) }
      it { should include Interval.new(1,79) }
    end

    context 'Test #3' do
      let(:a) { Interval.new(1,100) }
      let(:b) { [Interval.new(12,34),
                 Interval.new(12,34),
                 Interval.new(12,34)] }
      let(:x) { 3 }

      it { should include Interval.new(1,11) }
      it { should include Interval.new(35,100) }
    end

    context 'Test #4' do
      let(:a) { Interval.new(5,60) }
      let(:b) { [Interval.new(4,35)] }
      let(:x) { 1 }

      it { should eq Interval.new(36,60) }
    end

    context 'Test #5' do
      let(:a) { Interval.new(5,60) }
      let(:b) { [Interval.new(27,72)] }
      let(:x) { 1 }

      it { should eq Interval.new(5,26) }
    end

    context 'performance' do
      it "should be fast" do
        size = 100000
        xs = gen_intervals(0, 1440, size)
        is = xs.map { |x| Interval.new(x[0], x[1])}
        time = Benchmark.measure do
          n = 5
          a = is.shift
          b = is
          r = Interval.p1(a, b, n)
        end
        expect(time.total).to be < 4
        puts "Interval.p1 finished in #{'%.2f' % time.total}s"
      end
    end
  end

  describe "Problem #2" do
    subject { Interval.p2(intervals) }

    context 'Test #1' do
      let(:intervals) { [sched1,
                         sched2,
                         sched3,
                         sched4] }
      let(:sched1) { Interval.new("8:00", "9:00") }
      let(:sched2) { Interval.new("10:00", "11:15") }
      let(:sched3) { Interval.new("11:00", "12:30") }
      let(:sched4) { Interval.new("13:00", "14:30") }

      it { should eq [
                       [sched1, sched2, sched4],
                       [sched1, sched3, sched4],
                     ] }
    end

    context 'performance' do
      it "should be fast" do
        size = 100
        xs = gen_string_times(0, 1440, size)
        r = []
        time = Benchmark.measure do
          r = Interval.p2(xs)
        end
        expect(time.total).to be < 4
        puts "Interval.p2 finished in #{'%.2f' % time.total}s"
      end
    end
  end

  describe "Problem #3" do
  end
end
