# -*- coding: utf-8 -*-
# Name::      Automatic::Plugin::CustomFeed::SVNFLog
# Author::    kzgs
#             774 <http://id774.net>
# Created::   Mar  4, 2012
# Updated::   May  1, 2013
# Copyright:: kzgs Copyright (c) 2012-2013
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

require 'store/target_link'
require 'tmpdir'
require 'pathname'

describe Automatic::Plugin::StoreTargetLink do
  it "should store the target link" do
    Dir.mktmpdir do |dir|
      instance = Automatic::Plugin::StoreTargetLink.new(
        { "path" => dir },
        AutomaticSpec.generate_pipeline {
          feed { item "http://id774.net/test/store/rss" }
        }
      )
      instance.run.should have(1).feed
      (Pathname(dir)+"rss").should be_exist
    end
  end

  it "should error during file download" do
    Dir.mktmpdir do |dir|
      instance = Automatic::Plugin::StoreTargetLink.new(
        { "path" => dir },
        AutomaticSpec.generate_pipeline {
          feed { item "aaa" }
        }
      )
      instance.run.should have(1).feed
    end
  end

  it "should error and retry during file download" do
    Dir.mktmpdir do |dir|
      instance = Automatic::Plugin::StoreTargetLink.new(
        {
          "path" => dir,
          'retry' => 1,
          'interval' => 2
        },
        AutomaticSpec.generate_pipeline {
          feed { item "aaa" }
        }
      )
      instance.run.should have(1).feed
    end
  end

end
