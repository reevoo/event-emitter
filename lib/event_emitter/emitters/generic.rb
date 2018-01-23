require_relative "../exceptions"

module Emitters
  class Generic
    def self.publish(*)
      fail Emitters::NotImplementedError
    end
  end
end
