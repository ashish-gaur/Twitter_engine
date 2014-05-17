module Twitter3
  class RelationshipMailer < ActionMailer::Base
      default from: "Twitter"

	  def requests(follower, following, token)
	    @follower = follower
	    @following = following
	    @token = token
	    mail(:to => following.email, :subject => "#{@follower.username} wants to follow you")
	  end

	  def notify(follower, following, action)
	    @follower = follower
	    @following = following
	    @action = action
	    mail(:to => follower.email, :subject => "#{@following.username} has #{@action} your request")
	  end
  end
end
