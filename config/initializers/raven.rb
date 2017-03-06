Raven.configure do |config|
  config.environments = %w(production)

  logger = ::Logger.new(STDOUT)
  logger.level = ::Logger::WARN
  config.logger = logger
end
