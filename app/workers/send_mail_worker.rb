class SendMailWorker
  include Sidekiq::Worker

  def perform(content)
	LtcMonitorMailer.suggest_mail(content).deliver_now
  end
end