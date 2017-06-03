class LtcMonitorMailer < ApplicationMailer
	def suggest_mail(content)
		@content = content
		mail!(to: 'dejiegeng@gmail.com', subject: 'Suggestion From Jesus', date: Time.now)
	end
end
