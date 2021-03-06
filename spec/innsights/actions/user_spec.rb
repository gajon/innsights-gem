require 'spec_helper'

describe Innsights::Actions::User do
  let!(:report) { Innsights::Config::Report.new(Post) }
  let(:user) { User.create(:name => 'New user') }
  let(:post) { Post.create(:title => 'New post', :user => user ) }
  
  describe '#initialize' do
    it 'rescues the no method error upon defining non existing methods' do
      report.user :fake
      lambda { Innsights::Actions::User.new(report, post) }.should_not raise_error(NoMethodError)
    end
    it 'Acts on an object that has a user' do
      report.report_user = :user
      Post.any_instance.should_receive(:user).and_return(:user)
      Innsights::Actions::User.new(report, post)
    end

    it 'Acts on the directly on a user when indicated' do
      Innsights.user_call = :user
      Post.any_instance.should_not_receive(:user)
      u = Innsights::Actions::User.new(report, user)
      u.object.should == user
    end


  end
  
  describe '#valid?' do
    it 'is valid when it has a correct associated object' do
      user = Innsights::Actions::User.new(report, post)
      user.valid?.should == true
    end
    it 'is invalid when it doesnt have a correct associated object' do
      post.user_id = -1
      user = Innsights::Actions::User.new(report, post)
      user.valid?.should == false
    end
  end

  describe '#as_hash' do
    it 'returns the right user hash attributes' do
      app_user = Innsights::Actions::User.new(report, post)
      app_user.as_hash.should == {:id => user.id, :display => user.to_s }
    end
  end
  
end
