Raven.configure do |config|
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.dsn = ENV['SENTRY_DSN'] if ENV['SENTRY_DSN'].present?
  config.environments = ['staging', 'production']
end