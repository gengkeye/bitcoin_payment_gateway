class LtcMonitorMailer < ApplicationMailer
	def suggest_mail(email_id)
		@suggestion_email = SuggestionEmail.find_by(id: email_id)
		raise "Email not found." if @suggestion_email.nil?
		mail(to: %w(dejiegeng@gmail.com steven.c.j.huang@gmail.com),
			 subject: 'Suggestion From Jesus',
			 date: Time.now) do |format|
			format.html
		end
	end
end
