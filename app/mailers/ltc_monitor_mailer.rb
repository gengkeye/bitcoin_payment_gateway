class LtcMonitorMailer < ApplicationMailer
	def suggest_mail(email_id)
		@suggestion_email = SuggestionEmail.find_by(id: email_id)
		@last_email = SuggestionEmail.find_by(id: email_id - 1)
		raise "Email not found." if @suggestion_email.nil?
		@correct_nums = @last_email.correct_num.to_i
		@incorrect_nums = @last_email.incorrect_num.to_i
		total_nums = @correct_nums + @incorrect_nums
		@success_rate = (total_nums == 0 ? 0 : (@correct_nums.to_f / total_nums))
		mail(to: %w(dejiegeng@gmail.com steven.c.j.huang@gmail.com),
			 subject: 'Suggestion From Jesus',
			 date: Time.now) do |format|
			format.text
			format.html
		end
	end
end
