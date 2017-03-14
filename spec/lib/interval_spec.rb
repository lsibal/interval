# frozen_string_literal: true

require 'spec_helper'
require 'interval'

describe Interval do
  describe "Problem #1" do
    subject { Interval.p1(a, b, x).to_s }

    context 'Test #1' do
      let(:a) { Interval.new(1,100) }
      let(:b) { [Interval.new(1,50),
                 Interval.new(1,50),
                 Interval.new(1,50),
                 Interval.new(70,100),
                 Interval.new(80,90)] }
      let(:x) { 3 }

      it { should eq "51-100" }
    end

    context 'Test #2' do
      let(:a) { Interval.new(1,100) }
      let(:b) { [Interval.new(51,100),
                 Interval.new(51,100),
                 Interval.new(80,100),
                 Interval.new(80,100),
                 Interval.new(80,90)] }
      let(:x) { 2 }

      it { should eq "[1-50, 1-79]" }
    end

    context 'Test #3' do
      let(:a) { Interval.new(1,100) }
      let(:b) { [Interval.new(12,34),
                 Interval.new(12,34),
                 Interval.new(12,34)] }
      let(:x) { 3 }

      it { should eq "[1-11, 35-100]" }
    end

    context 'Test #4' do
      let(:a) { Interval.new(5,60) }
      let(:b) { [Interval.new(4,35)] }
      let(:x) { 1 }

      it { should eq "36-60" }
    end

    context 'Test #5' do
      let(:a) { Interval.new(5,60) }
      let(:b) { [Interval.new(27,72)] }
      let(:x) { 1 }

      it { should eq "5-26" }
    end
  end

  describe "Problem #2" do
  end

  describe "Problem #3" do
  end
end
