namespace :ds_tools do

  @ssh_user = ENV['SSH_USER'] || "root"
  @ssh_port = ENV['PORT'] || "22"
  @user = ENV['USERNAME'] || "admin"
  @group = ENV['GROUP'] || @user

  
  desc "Runs several initial server preparation tasks for Moonshine. Creates #{@user.capitalize} user as sudo. Changes root password."
  task :prepare do
    default_settings
    create_sudo_user
    change_root_password
  end


  desc "Change user password"
  task :change_user_password do
    default_settings
    change_password(@user)
  end


  desc "Change root password"
  task :change_root_password do
    default_settings
    change_password(@ssh_user)
  end


  desc "Creates a user on server"
  task :create_user do
    default_settings
    
    change_password(@user) do
      unless user_exists?(@user) 
        sudo "cat /etc/group" do |channel, stream, data|
          sudo "addgroup #{@group}" unless /#{@group}/.match(data)
          sudo "adduser #{@user.downcase} --quiet --ingroup #{@group} --disabled-password --gecos ''"
        end
      else
        puts "#{@user.capitalize} already exists"
      end
    end
  end


  desc "Add user to sudoers"
  task :add_user_as_sudo do  
    default_settings
    sudo "cat /etc/sudoers" do |channel, stream, data|
      sudo "echo '#{@user.downcase} ALL=(ALL) ALL' >> /etc/sudoers" unless /%#{@user.downcase}\s*ALL=\(ALL\)\s*ALL/.match(data)
    end
  end


  desc "Create user and add to sudoers"
  task :create_sudo_user do
    default_settings
    create_user
    add_user_as_sudo
  end
  
  
  desc "Add user to group"
  task :add_user_to_group do
    # the "-a" flag in usermod retains user's
    # current group(s) when adding new one
    # otherwise it would remove user
    # from all existing groups with the -G flag
    
    sudo "usermod -aG #{@group} #{@user}"
  end
  
  
  def default_settings
    set :user, @ssh_user
    set :port, @ssh_port
  end

  
  def change_password(user)
    prompt_for_new_password(user) do
      yield if block_given?

      sudo "passwd #{user.downcase}" do |channel, stream, data|
        case data
          when /Enter new/i then channel.send_data("#{new_user_password}\n")
          when /Retype new/i then channel.send_data("#{confirmed_new_user_password}\n")
          when /.*successfully.*/ then puts "#{user} user password changed successfully"
          else 
            puts "Setting #{user} password failed"
            puts data
        end  
      end
    end
  end
  

  def change_password_prompt(user)
    set(:new_user_password) { Capistrano::CLI.password_prompt("New #{user} password: ") }
    set(:confirmed_new_user_password) { Capistrano::CLI.password_prompt("RETYPE New #{user} password: ") }
  end

    
  def prompt_for_new_password(user)
    change_password_prompt(user)
    if (new_user_password == confirmed_new_user_password)
      yield if block_given?
    else
      puts
      puts "===== Passwords do not match - Please try again ====="
      prompt_for_new_password(user)
    end
  end  

    
  def user_exists?(user)
    result = false
    sudo "cat /etc/passwd" do |channel, stream, data|
      result = /^#{@user.downcase}:/.match(data) ? true : false
    end
    result
  end
end
