require File.dirname(__FILE__) + "/spec_helper.rb"

describe "Base" do

  before(:each) do
    HTTParty.stub!(:get)
    Scrobbler2::Base.api_key = "api_key"
    Scrobbler2::Base.api_secret = "api_secret"
  end

  it "should have attribute api key" do
    Scrobbler2::Base.api_key = "blah"
    Scrobbler2::Base.api_key.should == "blah"
  end

  it "should have attribute session_key" do
    Scrobbler2::Base.session_key = "blah"
    Scrobbler2::Base.session_key.should == "blah"
  end
  
  it "should have attribute api secret" do
    Scrobbler2::Base.api_secret = "blah"
    Scrobbler2::Base.api_secret.should == "blah"
  end
  
  describe "sign" do
    it "should return an md5 digest of the 'query_signature'" do
      Scrobbler2::Base.should_receive(:query_signature).with(:query).and_return('query_signature')
      Scrobbler2::Base.sign(:query).should == '4987b19cfbded59cd717b8ffd9f1a6bf'
    end
  end
  
  describe "query_signature" do
    it "should return an unencoded api_signature" do
      query = {:method => "artist.getInfo", :api_key => "api_key", :format => "json"}
      Scrobbler2::Base.query_signature(query).should == "api_keyapi_keyformatjsonmethodartist.getInfoapi_secret"
    end
    
  end
  
  describe "get" do 
    it "should call HTTParty.get" do
      HTTParty.should_receive(:get).with('http://ws.audioscrobbler.com/2.0/', {:query => {:method=>'artist.getInfo', :format=>'json', :api_key => 'api_key'}})
      Scrobbler2::Base.get('artist.getInfo', {})
    end
  end

  
  describe "auth_get" do
    it "should call HTTParty.get" do
      HTTParty.should_receive(:get).with('http://ws.audioscrobbler.com/2.0/', an_instance_of(Hash))
      Scrobbler2::Base.get_with_auth('artist.getInfo', {})
    end
    
    it "should set the query method" do
      HTTParty.should_receive(:get) do |url, options|
        options[:query][:method].should == 'artist.getInfo'
      end
      Scrobbler2::Base.get_with_auth('artist.getInfo', {})
    end
    
    it "should set the api_key" do
      HTTParty.should_receive(:get) do |url, options|
        options[:query][:api_key].should == 'api_key'
      end
      Scrobbler2::Base.get_with_auth('artist.getInfo', {})
    end
    
    it "should set the api_sginature" do
      Scrobbler2::Base.should_receive(:sign).with(an_instance_of(Hash)).and_return('signature')
      HTTParty.should_receive(:get) do |url, options|
        options[:query][:api_sig].should == 'signature'
      end
      Scrobbler2::Base.get_with_auth('artist.getInfo', {})
    end
  
  end

end


