module Rbac
  module HasRole
    def has_permission?(action, context)
      types = context.authorizing_role_types_for(action)
      has_role?(types, context)
    end

    def has_role?(types, context = nil)
      Array(types).any? do |type|
        type = Rbac::RoleType.build(type) unless type.respond_to?(:granted_to?)
        type.granted_to?(self, context)
      end
    end

    def has_explicit_role?(type, context = nil)
      type = Rbac::RoleType.build(type) unless type.respond_to?(:granted_to?)
      type.granted_to?(self, context, :explicit => true)
    end
  end
end