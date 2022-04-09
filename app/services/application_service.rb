class ApplicationService
  include Dry::Schema

  attr_reader :errors

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @errors = []
    validate_service_params(params)
    filter_params(params)
  end

  def call
    process if success?
    self
  rescue StandardError => e
    fail!(e.message)
  end

  def success?
    !failure?
  end

  def failure?
    @errors.any?
  end

  private

  def validate_service_params(params)
    errors = schema.call(params).errors.to_h
    fail!(errors) if errors.any?
  end

  def filter_params(params)
    @params = params.is_a?(Hash) ? params : {}
  end

  def fail!(messages)
    @errors += Array(messages)
    self
  end

  def start_service_in_transaction(service)
    return service if service.success?

    fail!(service.errors)
    raise ActiveRecord::Rollback
  end
end
