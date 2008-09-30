module TimelineFu
  module Fires
    def self.included(klass)
      klass.send(:extend, ClassMethods)
    end

    module ClassMethods
      def fires(event_type, opts)
        method_name = :"fire_#{event_type}_after_#{opts[:on]}"
        define_method(method_name) do
          create_options = [:target, :secondary_target, :actor].inject({}) do |memo, sym|
            memo[sym] = opts[sym] == :self ? self : send(opts[sym]) if opts[sym]
            memo
          end
          create_options[:event_type] = event_type
          
          TimelineEvent.create!(create_options)
        end
        
        send(:"after_#{opts[:on]}", method_name, :if => opts[:if])
      end
    end
  end
end
