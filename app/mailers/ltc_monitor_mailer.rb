class LtcMonitorMailer < ApplicationMailer
	def suggest_mail(email_id)
		@suggestion_email = SuggestionEmail.find_by(email_id).as_json
		raise "Email not found." if @content.nil?
		mail(to: ['dejiegeng@gmail.com', 'steven.c.j.huang@gmail.com'], subject: 'Suggestion From Jesus', date: Time.now) do |format|
			format.text
			format.html
		end
	end
end
