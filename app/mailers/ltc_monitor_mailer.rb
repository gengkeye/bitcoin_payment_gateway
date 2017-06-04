class LtcMonitorMailer < ApplicationMailer
	def suggest_mail(content)
		@content = content
		mail(to: ['dejiegeng@gmail.com', 'steven.c.j.huang@gmail.com'], subject: 'Suggestion From Jesus', date: Time.now) do |format|
			format.text
			format.html
		end
	end
end
