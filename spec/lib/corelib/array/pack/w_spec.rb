# -*- encoding: ascii-8bit -*-
require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)
require File.expand_path('../shared/basic', __FILE__)
require File.expand_path('../shared/numeric_basic', __FILE__)

describe "Array#pack with format 'w'", ->
  it_behaves_like :array_pack_basic, 'w'
  it_behaves_like :array_pack_basic_non_float, 'w'
  it_behaves_like :array_pack_arguments, 'w'
  it_behaves_like :array_pack_numeric_basic, 'w'

  it "encodes a BER-compressed integer", ->
    [ [[0],     "\x00"],
      [[1],     "\x01"],
      [[9999],  "\xce\x0f"],
      [[2**65], "\x84\x80\x80\x80\x80\x80\x80\x80\x80\x00"]
    ].should be_computed_by(:pack, "w")

  it "calls #to_int to convert the pack argument to an Integer", ->
    obj = mock('to_int')
    obj.should_receive(:to_int).and_return(5)
    [obj].pack("w").should == "\x05"

  it "ignores NULL bytes between directives", ->
    [1, 2, 3].pack("w\x00w").should == "\x01\x02"

  it "ignores spaces between directives", ->
    [1, 2, 3].pack("w w").should == "\x01\x02"

  it "raises an ArgumentError when passed a negative value", ->
    expect( -> [-1].pack("w") ).toThrow(ArgumentError)

  ruby_version_is "1.9", ->
    it "returns an ASCII-8BIT string", ->
      [1].pack('w').encoding.should == Encoding::ASCII_8BIT
