class LtcMonitorMailer < ApplicationMailer
	def suggest_mail(email_id)
		@content = SuggestionEmail.find_by(email_id)
		raise "Email not found." if @content.nil?
		mail(to: ['dejiegeng@gmail.com', 'steven.c.j.huang@gmail.com'], subject: 'Suggestion From Jesus', date: Time.now) do |format|
			format.text
			format.html
		end
	end
end
