namespace :user do
  desc "Send all users a consolidated email of all their orders"
  task :send_orders_confirmation_mail => [:environment] do
    User.all.each do |user|
      puts "Sending mail to #{user.name} with email #{user.email}"
      OrderMailer.all_orders_confirmation(user).headers_field(server_pid: Process.pid).deliver_later
    end
    puts "Consolidated email successfully send to all users"
  end
end
