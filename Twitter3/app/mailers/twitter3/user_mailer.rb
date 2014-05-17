module Twitter3
  class UserMailer < ActionMailer::Base
    default from: "Twitter"

	def registration_confirmation(user)
	@user = user
	#token = Digest::SHA1.hexdigest([Time.now, rand].join)
	mail(:to => user.email, :subject => 'Confirmation for registration')
	end
  end
end
