class LtcMonitorMailer < ApplicationMailer
	def suggest_mail(email_id)
		@suggestion_email = SuggestionEmail.find_by(id: email_id)
		raise "Email not found." if @content.nil?
		@correct_nums = @suggestion_email.correct_num
		@incorrect_nums = @suggestion_email.incorrect_num
		@success_rate = @correct_nums.to_f / (@correct_nums + @incorrect_nums)
		mail(to: ['dejiegeng@gmail.com', 'steven.c.j.huang@gmail.com'], subject: 'Suggestion From Jesus', date: Time.now) do |format|
			format.text
			format.html
		end
	end
end
