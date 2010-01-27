class MoonshineDsToolsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "app/manifests/application_manifest.rb", "app/manifests/application_manifest.rb"
      m.file "config/moonshine.yml", "config/moonshine.yml"
      m.file "config/deploy.rb", "config/deploy.rb"
      m.directory "config/deploy"
      m.file "config/deploy/staging.rb", "config/deploy/staging.rb"
      m.file "config/deploy/production.rb", "config/deploy/production.rb"
    end
  end
end