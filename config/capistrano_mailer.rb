
unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    namespace :email do

      desc <<-DESC
        Creates the initializers/mailer.rb
      DESC
      task :setup, :except => { :no_release => true } do

        smtpserver = Capistrano::CLI.ui.ask("Enter smtp server name: ")
        domain = Capistrano::CLI.ui.ask("Enter domain name: ")
        username = Capistrano::CLI.ui.ask("Enter smtp server username: ")
        password = Capistrano::CLI.ui.ask("Enter smtp server password: ")

        template = <<-EOF
          ActionMailer::Base.smtp_settings = {
              :address => "<%= smtpserver %>",
              :port => 25,
              :domain => "<%= domain %>",
              :authentication => :login,
              :user_name => "<%= username %>",
              :password => "<%= password %>"
            }
        EOF

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/config" 
        run "mkdir -p #{shared_path}/config/initializers" 
        put config.result(binding), "#{shared_path}/config/initializers/mailer.rb"
      end

      desc <<-DESC
        [internal] Updates the symlink for initializers/mailer.rb file to the just deployed release.
      DESC
      task :symlink, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/initializers/mailer.rb #{release_path}/config/initializers/mailer.rb" 
      end

    end

    after "deploy:setup",           "deploy:email:setup"   
    after "deploy:finalize_update", "deploy:email:symlink"

  end

end
