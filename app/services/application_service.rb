# frozen_string_literal: true

class ApplicationService
  attr_reader :result, :error, :status

  def self.call(*args)
    new(*args).tap do |service|
      service.instance_eval do
        @result = call
      end
    end
  end

  def self.attributes(*attributes)
    @attributes = *attributes
  end

  def initialize(args = {})
    attributes = self.class.instance_variable_get('@attributes') || []

    attributes.each do |attribute|
      instance_variable_set("@#{attribute}", args[attribute])
      self.class.send(:attr_reader, attribute)
    end
  end

  def failure(error_type, status = nil)
    @error = error_type
    @status = status.present? ? status.to_sym : :ok
    raise(error) if error.is_a?(Class) && (error < Exception)
  end

  def success?
    @error.nil?
  end

  def translated_error(message, scope = nil)
    I18n.t(
      message.to_s.parameterize(separator: '_').to_sym,
      scope: ['errors', 'translated_errors', scope].compact.join('.'),
      default: message.to_s
    )
  end
end
