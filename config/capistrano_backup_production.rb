unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :backup do
  
    desc <<-DESC
      Backup database from production.
      Set backup_dir variabele for local destination of the backup files
    DESC
    task :mysql, :roles => :db, :only => { :primary => true } do
      filename = "#{application}.mysql.#{Time.now.strftime '%Y%m%d-%H%M%S'}.sql.bz2"
      remote_file = "/tmp/#{filename}"
      text = capture "cat #{deploy_to}/current/config/database.yml"
      yaml = YAML::load(text)
   
      on_rollback { run "rm #{remote_file}" }
      run "mysqldump -u #{yaml['production']['username']} -p #{yaml['production']['database']} | bzip2 -c > #{remote_file}" do |ch, stream, out|
        ch.send_data "#{yaml['production']['password']}\n" if out =~ /^Enter password:/
      end
      download remote_file, "#{backup_dir}/#{filename}"
      run "rm #{remote_file}"
    end  
    
    
    desc <<-DESC
      Backup the files in the shared/system path from production.
      Set backup_dir variabele for local destination of the backup files
    DESC
    task :assets, :role => :app, :only => { :primary => true } do
      filename = "#{application}.system.#{Time.now.strftime '%Y%m%d-%H%M%S'}.tgz"
      remote_file = "/tmp/#{filename}"
      invoke_command "cd #{shared_path} && tar czf #{remote_file} system"
      download remote_file, "#{backup_dir}/#{filename}"      
      run "rm #{remote_file}"
    end
    
    desc <<-DESC
      Backup the database and the files in the shared/system path from production.
      Set backup_dir variabele for local destination of the backup files
    DESC
    task :default, :role => [:app, :db], :only => { :primary => true } do
      mysql
      assets
    end    
  end
end

