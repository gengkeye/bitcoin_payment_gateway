class SendMailWorker
  include Sidekiq::Worker

  def perform(content)
	LtcMonitorMailer.suggest_mail(content)
  end
end