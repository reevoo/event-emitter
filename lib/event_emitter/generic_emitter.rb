class GenericEmitter
  def self.publish(*)
    fail NotImplementedError
  end
end
