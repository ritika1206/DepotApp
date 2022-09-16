class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  before_action :send_process_id_in_headers

  def send_process_id_in_headers
    headers['X-SYSTEM-PROCESS-ID'] = Process.pid
  end
end
