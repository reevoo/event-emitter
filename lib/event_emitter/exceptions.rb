module Emitters
  class Error < StandardError; end

  class UnsupportedBackendError < Error; end

  class NotImplementedError < Error; end
end
