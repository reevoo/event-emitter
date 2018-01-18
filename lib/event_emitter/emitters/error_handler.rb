module Emitters
  class ErrorHandler

    def self.handle_exception(params, &_block)
      yield
      true
    rescue Exception => error # rubocop:disable Lint/RescueException
      # TODO: Figure out what to do with this shit if we pass logger in configuration
      if defined?(Raven)
        Raven.capture_exception(error)
      elsif defined?(Sapience)
        Sapience.logger.error!("Error trying to emit event", params, error)
        Sapience.metrics.increment("exception", tags: ["event_emitter", params[:entity_name].to_s])
      else
        # inform about adding error handler
      end
      raise error if params[:raise_errors]
      false
    end

  end
end
