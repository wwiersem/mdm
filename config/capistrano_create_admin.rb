unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    namespace :admin do

      desc <<-DESC
        Creates the inital admmin user, prompts for username and password 
				
				Be careful: shows password in cleartext
      DESC
      task :setup, :except => { :no_release => true } do

					username = Capistrano::CLI.ui.ask("Enter admin username: ")
					password = Capistrano::CLI.ui.ask("Enter admin password: ")
					run "cd #{release_path} && script/runner -e production 'User.create( :name => \"#{username}\", :password => \"#{password}\", :password_confirmation => \"#{password}\")'"
      end
    end
  end
end
