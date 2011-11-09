# Steps to doing an initial deployment:
#
# Create system user "pgxn"
# cap deploy:setup
# cap deploy:cold -s branch=$tag
# cap deploy -s branch=$tag

load 'deploy'

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :application, "site"
set :domain,      "pgxn.org"
set :repository,  "https://github.com/pgxn/pgxn-site.git"
set :scm,         :git
set :deploy_via,  :remote_cache
set :use_sudo,    false
set :branch,      "master"
set :deploy_to,   "~/pgxn-site"
set :run_from,    "/var/www/#{domain}"

# Prevent creation of Rails-style shared directories.
set :shared_children, %()

role :app, 'xanthan.postgresql.org'

namespace :deploy do
  desc 'Confirm attempts to deploy master'
  task :check_branch do
    if self[:branch] == 'master'
      unless Capistrano::CLI.ui.agree("\n    Are you sure you want to deploy master? ")
        puts "\n", 'Specify a branch via "-s branch=vX.X.X"', "\n"
        exit
      end
    end
  end

  task :finalize_update, :except => { :no_release => true } do
    # Build it!
    run <<-CMD
      cd #{ latest_release };
      perl Build.PL || exit $?;
      ./Build installdeps || exit $?;
      ./Build || exit $?;
      ln -s #{shared_path}/www #{latest_release}/www;
    CMD
  end

  task :start_script do
    top.upload 'eg/debian_init', '/tmp/pgxn-site', :mode => 0755
    run 'sudo mv /tmp/pgxn-site /etc/init.d/ && sudo /usr/sbin/update-rc.d pgxn-site defaults'
  end

  task :symlink_production do
    run "sudo ln -fs #{ latest_release } #{ run_from }"
  end

  task :migrate do
    # Do nothing.
  end

  task :start do
    run 'sudo /etc/init.d/pgxn-site start'
  end

  task :restart do
    run 'sudo /etc/init.d/pgxn-site restart'
  end

  task :stop do
    run 'sudo /etc/init.d/pgxn-site stop'
  end

end

before 'deploy:update',  'deploy:check_branch'
after  'deploy:update',  'deploy:start_script'
after  'deploy:symlink', 'deploy:symlink_production'
