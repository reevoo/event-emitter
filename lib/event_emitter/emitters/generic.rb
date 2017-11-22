module Emitters
  class Generic
    def self.publish(*)
      fail NotImplementedError
    end
  end
end
