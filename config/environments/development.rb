Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = {host: 'localhost', port: 3000}
  #   # DPS: this works for gmail direct (no brevo)
  ActionMailer::Base.smtp_settings = {
    address:        'smtp.gmail.com',
    port:           '587',
    authentication: 'plain',
    user_name:      'woodytrackharrow@gmail.com',
    password:        ENV['WTH_GMAIL_APP_PASSWORD'],
    domain:         'gmail.com',
    enable_starttls_auto: true
  } 

  # DPS: attempt to use Brevo - authentication error
  # config.action_mailer.smtp_settings = {
  # address:              'smtp-relay.brevo.com',
  # port:                 587,
  # domain:               'gmail.com',
  # user_name:            'myemail@gmail.com',
  # password:             'xsmtpsib-....', # Long Brevo SMTP password
  # authentication:       'login',
  # enable_starttls_auto: true
  # }

  # DPS MH 11.22
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.delivery_method = :test

  # config.action_mailer.default_url_options = {host: 'localhost', port: 3000, protocol: 'http'}

  # DPS so changes are reflected without having to reload public_file_server
  # stackoverflow "server needs restart every time I make changes"
  # issues arose after shift to WSL
  # config.reload_classes_only_on_change = false
  # config.serve_static_assets = false

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.

  # DPS commented out per stackoverflow "server needs restart every time I make changes"
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
