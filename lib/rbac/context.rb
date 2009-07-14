module Rbac
  class Context
    mattr_accessor :default_permissions
    self.default_permissions = {}

    class << self
      def root
        @root ||= Base.new(self)
      end
      
      def define_class(model, options)
        returning Class.new(Base) do |klass|
          model.const_set('RoleContext', klass).class_eval do
            self.parent = options.delete(:parent)
            self.parent_accessor = options.delete(:parent_accessor)
            # self.parent_accessor ||= self.parent.name.underscore.to_sym if self.parent
            self.options = options
          end
        end
      end
    end
    
    class Base
      class_inheritable_accessor :parent, :parent_accessor, :options, :children
      self.options  = {}
      self.children = []
      
      attr_accessor :object

      def initialize(object = nil)
        self.object = object
      end

      def authorizing_roles_for(action)
        raise("No action given (on: #{self.inspect})") unless action

        result = self.permissions[action.to_sym] ||
          parent.try(:authorizing_roles_for, action) ||
          raise(AuthorizingRoleNotFound.new("Could not find role(s) for #{action} (on: #{self.inspect})"))
          
        Array(result)
      end

      def include?(context)
        return false unless context
        begin 
          return true if self == context
        end while context = context.parent
        false
      end
    
      def parent
        if parent_accessor and parent = object.send(parent_accessor)
          parent.role_context
        elsif self != Rbac::Context.root
          Rbac::Context.root # might want to return a fake domain model here
        end
      end
      
      def ==(other)
        object == other.object
      end

      protected

        def permissions
          return Rbac::Context.default_permissions if self.class == Rbac::Context::Base
          @permissions ||= (object.try(:permissions) || {}).symbolize_keys
        end
    end
  end
end