namespace :user do
  desc "Marking an existing user as admin"
  task :mark_as_admin, [:email] => [:environment] do |task, arg|
    updated_user = User.where(email: arg[:email]).update!(role: 'admin')
    puts "#{updated_user.first.name} is successfully marked as admin"
  end
end
