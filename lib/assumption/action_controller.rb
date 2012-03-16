module Assumption
  module ActionController
    mattr_accessor :interrupt
    extend ActiveSupport::Concern

    module ClassMethods
      def assume(options, &block)
        before_filter :only => options[:only], :except => options[:except] do
          result = Assumption.assume(params, options)

          return true if result.valid?
          block.call if block
          Assumption::ActionController.interrupt.call if Assumption::ActionController.interrupt
          raise Assumption::InvalidError
        end
      end
    end
  end
end

ActionController::Base.send :include, Assumption::ActionController
