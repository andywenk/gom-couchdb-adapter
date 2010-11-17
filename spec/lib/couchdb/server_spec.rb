require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "lib", "couchdb", "server"))

describe CouchDB::Server do

  before :each do
    Transport::JSON.stub(:request)
    @server = CouchDB::Server.new "host", 1234
  end

  describe "initialize" do

    it "should set the host" do
      @server.host.should == "host"
    end

    it "should set the port" do
      @server.port.should == 1234
    end

  end

  describe "==" do

    it "should be true when comparing two equal servers" do
      @server.should == described_class.new("host", 1234)
    end

    it "should be false when comparing two different servers" do
      @server.should_not == described_class.new("other", 1234)
    end

  end

  describe "informations" do

    it "should request server informations" do
      Transport::JSON.should_receive(:request).with(
        :get,
        "http://host:1234/",
        :expected_status_code => 200
      ).and_return("result")
      @server.informations.should == "result"
    end

  end

  describe "statistics" do

    it "should request server statistics" do
      Transport::JSON.should_receive(:request).with(
        :get,
        "http://host:1234/_stats",
        :expected_status_code => 200
      ).and_return("result")
      @server.statistics.should == "result"
    end

  end

  describe "database_names" do

    it "should request the names of all databases" do
      Transport::JSON.should_receive(:request).with(
        :get,
        "http://host:1234/_all_dbs",
        :expected_status_code => 200
      ).and_return("result")
      @server.database_names.should == "result"
    end

  end

  describe "uuids" do

    it "should request a given number of uuids" do
      Transport::JSON.should_receive(:request).with(
        :get,
        "http://host:1234/_uuids",
        :expected_status_code => 200,
        :parameters => { :count => 3 }
      ).and_return({ "uuids" => "result" })
      @server.uuids(3).should == "result"
    end

  end

end