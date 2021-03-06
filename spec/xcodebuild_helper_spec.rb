require File.expand_path('../spec_helper', __FILE__)

SPEC_XCODEBUILD_SAMPLE_SDK_OTPUT = <<-DOC
OS X SDKs:
	Mac OS X 10.7                 	-sdk macosx10.7
	OS X 10.8                     	-sdk macosx10.8

iOS SDKs:
	iOS 6.1                       	-sdk iphoneos6.1

iOS Simulator SDKs:
	Simulator - iOS 6.1           	-sdk iphonesimulator6.1
DOC

module Xcodeproj

  describe XcodebuildHelper do

    before do
      @sut = XcodebuildHelper.new
      @sut.stubs(:xcodebuild_sdks).returns(SPEC_XCODEBUILD_SAMPLE_SDK_OTPUT)
    end

    #--------------------------------------------------------------------------------#

    describe "In general" do

      it "returns the last iOS SDK" do
        @sut.last_ios_sdk.should == '6.1'
      end

      it "returns the last OS X SDK" do
        @sut.last_osx_sdk.should == '10.8'
      end

    end

    #--------------------------------------------------------------------------------#

    describe "Private helpers" do

      describe "#xcodebuild_available?" do

        it "returns whether the xcodebuild command is available" do
          Process::Status.any_instance.expects(:exitstatus).returns(0)
          @sut.send(:xcodebuild_available?).should.be.true
        end

        it "returns whether the xcodebuild command is available" do
          Process::Status.any_instance.expects(:exitstatus).returns(1)
          @sut.send(:xcodebuild_available?).should.be.false
        end

      end

      describe "#parse_sdks_information" do

        it "parses the skds information returned by xcodebuild" do
          result = @sut.send(:parse_sdks_information, SPEC_XCODEBUILD_SAMPLE_SDK_OTPUT)
          result.should == [["macosx", "10.7"], ["macosx", "10.8"], ["iphoneos", "6.1"]]
        end

      end
    end

    #--------------------------------------------------------------------------------#

  end
end
