require_relative "../helper"

require "etc"

## DISCUSS TEST BRITTLENESS, MAYBE ALLOW CONFIG FILE OVERRIDES?
# OR JUST MENTION IT'S A SPECIAL CASE ENVIRONMENT

describe "FileDetails" do

  let(:plain_file) { FileDetails.new("#{DATA_DIR}/hello.txt") }
  let(:executable) { FileDetails.new("#{DATA_DIR}/hello.sh") }
  let(:dir)        { FileDetails.new("#{DATA_DIR}/foo") }

  it "must provide permission details" do
    plain_file.permissions.must_equal("-rw-r--r--")
    executable.permissions.must_equal("-rwxr-xr-x")
    dir.permissions.must_equal("drwxr-xr-x")
  end

  it "must provide link count" do
    plain_file.links.must_equal(1)
    executable.links.must_equal(1)
    dir.links.must_equal(7)
  end

  it "must provide group name" do
    plain_file.group.must_equal("staff")
    executable.group.must_equal("staff")
    dir.group.must_equal("staff")
  end

  it "must provide owner account name" do
    plain_file.owner.must_equal("seacreature")
    executable.owner.must_equal("seacreature")
    dir.owner.must_equal("seacreature")
  end

  it "must provide size" do
    plain_file.size.must_equal(13)
    executable.size.must_equal(39)
    dir.size.must_equal(238)
  end

  it "must provide modified time (mtime)" do
    plain_file.mtime.must_equal("Apr  8 15:09")
    executable.mtime.must_equal("Apr  8 15:09")
    dir.mtime.must_equal("Apr  8 15:09")
  end
end
