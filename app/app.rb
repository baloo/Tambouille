class Tambouille < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  ##
  # Caching support
  #
  # register Padrino::Cache
  # enable :caching
  #
  # You can customize caching store engines:
  #
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Memcached.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Memcache.new(::Dalli::Client.new('127.0.0.1:11211', :exception_retry_limit => 1))
  #   set :cache, Padrino::Cache::Store::Redis.new(::Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0))
  #   set :cache, Padrino::Cache::Store::Memory.new(50)
  #   set :cache, Padrino::Cache::Store::File.new(Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
  #

  ##
  # Application configuration options
  #
  # set :raise_errors, true     # Raise exceptions (will stop application) (default for test)
  # set :dump_errors, true      # Exception backtraces are written to STDERR (default for production/development)
  # set :show_exceptions, true  # Shows a stack trace in browser (default for development)
  # set :logging, true          # Logging in STDOUT for development and file for production (default only for development)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (default your_app/locales)
  # disable :sessions           # Disabled sessions by default (enable if needed)
  # disable :flash              # Disables rack-flash (enabled by default if Rack::Flash is defined)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  set :mailer_defaults, :from => 'tambouille@a30.zenexity.com'

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
  error 404 do
    @error = env['sinatra.error']
    render 'errors/404'
  end
  #
  #   error 505 do
  #     render 'errors/505'
  #   end
  #

  @@config = {}

  def self.config(arg = nil)
    if arg
      @@config = TambouilleConfig.load(arg)
    end
    @@config
  end

end

# Monkey patching is ugly, you should never ever do that
# but it's so much powerfull
class Hash
  def recursive_merge(h)
    self.merge!(h) {|key, _old, _new| if _old.class == Hash then _old.recursive_merge(_new) else _new end  }
  end
end

class TambouilleConfig < Hash
  def self.load(environment)
    # load global config file
    root_config = YAML.load_file(Padrino.root + '/config/tambouille.yml')

    # override config file with local file
    if File.exists?(Padrino.root + '/config/tambouille.yml.local')
      local_root_config = YAML.load_file(Padrino.root + '/config/tambouille.yml.local')
      root_config.recursive_merge(local_root_config)
    end

    # Merge environment config with global_config
    env_config = root_config[environment] || {}
    config = root_config["all"] || {}
    config.recursive_merge(env_config)

    # Get an TambouilleConfig back
    tc = TambouilleConfig.new()
    tc.merge!(config)
    tc
  end

  def setup()
    Padrino.logger.info("[chef] Setup chef client library")

    if self["chef"]["config_file"]
      Padrino.logger.debug("[chef] Load config file")
      Chef::Config.from_file(self["chef"]["config_file"])
    end

    # If any overrides then load them
    if self["chef"]["overrides"]
      Padrino.logger.debug("[chef] Load overrides")
      self["chef"]["overrides"].each{ |key, value|
        Chef::Config[key.to_sym] = value
      }
    end
  end
end


