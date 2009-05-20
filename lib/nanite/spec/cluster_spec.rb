require File.join(File.dirname(__FILE__), 'spec_helper')

describe Nanite::Cluster do

  describe "Intialization" do

    before(:each) do
      @fanout = mock("fanout")
      @binding = mock("binding", :subscribe => true)
      @queue = mock("queue", :bind => @binding)
      @amq = mock("AMQueue", :queue => @queue, :fanout => @fanout)
      @serializer = mock("Serializer")
      @reaper = mock("Reaper")
      @mapper = mock("Mapper")
      Nanite::Reaper.stub!(:new).and_return(@reaper)
    end

    describe "of Heartbeat (Queue)" do

      it "should setup the heartbeat (queue) for id" do
        @amq.should_receive(:queue).with("heartbeat-the_identity", anything()).and_return(@queue)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

      it "should make the heartbeat (queue) exclusive" do
        @amq.should_receive(:queue).with("heartbeat-the_identity", { :exclusive => true }).and_return(@queue)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

      it "should bind the heartbeat (queue) to 'heartbeat' fanout" do
        @amq.should_receive(:fanout).with("heartbeat", { :durable => true }).and_return(@fanout)
        @queue.should_receive(:bind).with(@fanout).and_return(@binding)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

    end # of Heartbeat (Queue)


    describe "of Registration (Queue)" do

      it "should setup the registration (queue) for id" do
        @amq.should_receive(:queue).with("registration-the_identity", anything()).and_return(@queue)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

      it "should make the registration (queue) exclusive" do
        @amq.should_receive(:queue).with("registration-the_identity", { :exclusive => true }).and_return(@queue)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

      it "should bind the registration (queue) to 'registration' fanout" do
        @amq.should_receive(:fanout).with("registration", { :durable => true }).and_return(@fanout)
        @queue.should_receive(:bind).with(@fanout).and_return(@binding)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

    end # of Registration (Queue)

    describe "of Request (Queue)" do

      it "should setup the request (queue) for id" do
        @amq.should_receive(:queue).with("request-the_identity", anything()).and_return(@queue)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

      it "should make the request (queue) exclusive" do
        @amq.should_receive(:queue).with("request-the_identity", { :exclusive => true }).and_return(@queue)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

      it "should bind the request (queue) to 'request' fanout" do
        @amq.should_receive(:fanout).with("request", { :durable => true }).and_return(@fanout)
        @queue.should_receive(:bind).with(@fanout).and_return(@binding)
        cluster = Nanite::Cluster.new(@amq, 10, "the_identity", @serializer, @mapper)
      end

    end # of Request (Queue)


    describe "Reaper" do

      it "should be created" do
        Nanite::Reaper.should_receive(:new).with(anything()).and_return(@reaper)
        cluster = Nanite::Cluster.new(@amq, 32, "the_identity", @serializer, @mapper)
      end

      it "should use the agent timeout" do
        Nanite::Reaper.should_receive(:new).with(443).and_return(@reaper)
        cluster = Nanite::Cluster.new(@amq, 443, "the_identity", @serializer, @mapper)
      end

    end # Reaper

  end # Intialization


  describe "Target Selection" do

    before(:each) do
      @fanout = mock("fanout")
      @binding = mock("binding", :subscribe => true)
      @queue = mock("queue", :bind => @binding)
      @amq = mock("AMQueue", :queue => @queue, :fanout => @fanout)
      @serializer = mock("Serializer")
      @reaper = mock("Reaper")
      Nanite::Reaper.stub!(:new).and_return(@reaper)
      @cluster = Nanite::Cluster.new(@amq, 32, "the_identity", @serializer, @mapper)
    end

    it "should return array containing targets for request" do
      target = mock("Supplied Target")
      request = mock("Request", :target => target)
      @cluster.targets_for(request).should be_instance_of(Array)
    end

    it "should use target from request" do
      target = mock("Supplied Target")
      request = mock("Request", :target => target)
      @cluster.targets_for(request).should == [target]
    end

    it "should use targets choosen by least loaded selector (:least_loaded)" do
      targets = { "target 3" => 3 }
      request = mock("Request", :target => nil, :selector => :least_loaded, :type => "service", :tags => [])
      @cluster.should_receive(:least_loaded).with("service", []).and_return(targets)
      @cluster.targets_for(request).should == ["target 3"]
    end

    it "should use targets choosen by all selector (:all)" do
      targets = { "target 1" => 1, "target 2" => 2, "target 3" => 3 }
      request = mock("Request", :target => nil, :selector => :all, :type => "service", :tags => [])
      @cluster.should_receive(:all).with("service", []).and_return(targets)
      @cluster.targets_for(request).should == ["target 1", "target 2", "target 3"]
    end

    it "should use targets choosen by random selector (:random)" do
      targets = { "target 3" => 3 }
      request = mock("Request", :target => nil, :selector => :random, :type => "service", :tags => [])
      @cluster.should_receive(:random).with("service", []).and_return(targets)
      @cluster.targets_for(request).should == ["target 3"]
    end

    it "should use targets choosen by round-robin selector (:rr)" do
      targets = { "target 2" => 2 }
      request = mock("Request", :target => nil, :selector => :rr, :type => "service", :tags => [])
      @cluster.should_receive(:rr).with("service", []).and_return(targets)
      @cluster.targets_for(request).should == ["target 2"]
    end

  end # Target Selection


  describe "Nanite Registration" do

    before(:each) do
      @fanout = mock("fanout")
      @binding = mock("binding", :subscribe => true)
      @queue = mock("queue", :bind => @binding)
      @amq = mock("AMQueue", :queue => @queue, :fanout => @fanout)
      @serializer = mock("Serializer")
      @reaper = mock("Reaper", :timeout => true)
      Nanite::Log.stub!(:info)
      Nanite::Reaper.stub!(:new).and_return(@reaper)
      @cluster = Nanite::Cluster.new(@amq, 32, "the_identity", @serializer, @mapper)
      @register_packet = Nanite::Register.new("nanite_id", ["the_nanite_services"], "nanite_status",[])
    end

    it "should add the Nanite to the nanites map" do
      @cluster.register(@register_packet)
      @cluster.nanites['nanite_id'].should_not be_nil
    end

    it "should use hash of the Nanite's services and status as value" do
      @cluster.register(@register_packet)
      @cluster.nanites['nanite_id'].keys.size == 2
      @cluster.nanites['nanite_id'].keys.should include(:services)
      @cluster.nanites['nanite_id'].keys.should include(:status)
      @cluster.nanites['nanite_id'][:services].should ==  ["the_nanite_services"]
      @cluster.nanites['nanite_id'][:status].should ==  "nanite_status"
    end

    it "should add nanite to reaper" do
      @reaper.should_receive(:timeout).with('nanite_id', 33)
      @cluster.register(@register_packet)
    end

    it "should log info message that nanite was registered" do
      Nanite::Log.should_receive(:info)
      @cluster.register(@register_packet)
    end

  end # Nanite Registration


  describe "Route" do

    before(:each) do
      @fanout = mock("fanout")
      @binding = mock("binding", :subscribe => true)
      @queue = mock("queue", :bind => @binding)
      @amq = mock("AMQueue", :queue => @queue, :fanout => @fanout)
      @serializer = mock("Serializer")
      @reaper = mock("Reaper")
      Nanite::Reaper.stub!(:new).and_return(@reaper)
      @cluster = Nanite::Cluster.new(@amq, 32, "the_identity", @serializer, @mapper)
      @request = mock("Request")
    end

    it "should publish request to all targets" do
      target1 = mock("Target 1")
      target2 = mock("Target 2")
      @cluster.should_receive(:publish).with(@request, target1)
      @cluster.should_receive(:publish).with(@request, target2)
      EM.run {
        @cluster.route(@request, [target1, target2])
        EM.stop
      }
    end

  end # Route


  describe "Publish" do

    before(:each) do
      @fanout = mock("fanout")
      @binding = mock("binding", :subscribe => true)
      @queue = mock("queue", :bind => @binding, :publish => true)
      @amq = mock("AMQueue", :queue => @queue, :fanout => @fanout)
      @serializer = mock("Serializer", :dump => "dumped_value")
      @reaper = mock("Reaper")
      Nanite::Reaper.stub!(:new).and_return(@reaper)
      @cluster = Nanite::Cluster.new(@amq, 32, "the_identity", @serializer, @mapper)
      @request = mock("Request", :persistent => true)
      @target = mock("Target of Request")
    end

    it "should serialize request before publishing it" do
      @serializer.should_receive(:dump).with(@request).and_return("serialized_request")
      @cluster.publish(@request, @target)
    end

    it "should publish request to target queue" do
      @queue.should_receive(:publish).with("dumped_value", anything())
      @cluster.publish(@request, @target)
    end

    it "should persist request based on request setting" do
      @request.should_receive(:persistent).and_return(false)
      @queue.should_receive(:publish).with(anything(), { :persistent => false })
      @cluster.publish(@request, @target)
    end

  end # Publish
  
  describe "Agent Request Handling" do

    before(:each) do
      @fanout = mock("fanout")
      @binding = mock("binding", :subscribe => true)
      @queue = mock("queue", :bind => @binding, :publish => true)
      @amq = mock("AMPQueue", :queue => @queue, :fanout => @fanout)
      @serializer = mock("Serializer", :dump => "dumped_value")
      @target = mock("Target of Request")
      @reaper = mock("Reaper")
      Nanite::Reaper.stub!(:new).and_return(@reaper)
      @request_without_target = mock("Request", :target => nil, :token => "Token",
       :reply_to => "Reply To", :from => "From", :persistent => true, :identity => "Identity")
      @request_with_target = mock("Request", :target => "Target", :token => "Token",
       :reply_to => "Reply To", :from => "From", :persistent => true)
      @mapper_with_target = mock("Mapper", :identity => "id")
      @mapper_without_target = mock("Mapper", :request => false, :identity => @request_without_target.identity)
      @cluster_with_target = Nanite::Cluster.new(@amq, 32, "the_identity", @serializer, @mapper_with_target)
      @cluster_without_target = Nanite::Cluster.new(@amq, 32, "the_identity", @serializer, @mapper_without_target)
      Nanite::Cluster.stub!(:mapper).and_return(@mapper)
    end
    
    it "should forward requests with targets" do
      @mapper_with_target.should_receive(:send_request).with(@request_with_target, anything())
      @cluster_with_target.__send__(:handle_request, @request_with_target)
    end
    
    it "should reply back with nil results for requests with no target when offline queue is disabled" do
      @mapper_without_target.should_receive(:send_request).with(@request_without_target, anything())
      Nanite::Result.should_receive(:new).with(@request_without_target.token, @request_without_target.from, nil, @request_without_target.identity)
       @cluster_without_target.__send__(:handle_request, @request_without_target)
    end
    
  end # Agent Request Handling

end # Nanite::Cluster
