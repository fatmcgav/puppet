#! /usr/bin/env ruby
require 'spec_helper'
require 'puppet'
require 'puppet_spec/files'
require 'semver'

describe Puppet do
  include PuppetSpec::Files

  context "#version" do
    it "should be valid semver" do
      SemVer.should be_valid Puppet.version
    end
  end

  Puppet::Util::Log.eachlevel do |level|
    it "should have a method for sending '#{level}' logs" do
      Puppet.should respond_to(level)
    end
  end

  it "should be able to change the path" do
    newpath = ENV["PATH"] + File::PATH_SEPARATOR + "/something/else"
    Puppet[:path] = newpath
    ENV["PATH"].should == newpath
  end

  it "should change $LOAD_PATH when :libdir changes" do
    one = tmpdir('load-path-one')
    two = tmpdir('load-path-two')
    three = tmpdir('load-path-three')
    one.should_not == two
    one.should_not == three

    Puppet[:libdir] = one
    $LOAD_PATH.should include one
    $LOAD_PATH.should_not include two
    $LOAD_PATH.should_not include three

    Puppet[:libdir] = two
    $LOAD_PATH.should_not include one
    $LOAD_PATH.should include two
    $LOAD_PATH.should_not include three

    Puppet[:libdir] = [one, three].join(':')
    $LOAD_PATH.should include one
    $LOAD_PATH.should_not include two
    $LOAD_PATH.should include three
    
  end
end
