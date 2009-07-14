module Rbac
  module HasRole
    def has_permission?(action, context)
      roles = context.authorizing_roles_for(action)
      has_role?(roles, context)
    end

    def has_role?(role, context = nil)
      role = Rbac::Role.build(role) unless role.respond_to?(:granted_to?)
      role.granted_to?(self)
    end

    def has_explicit_role?(role, context = nil)
      role = Rbac::Role.build(role) unless role.respond_to?(:granted_to?)
      role.granted_to?(self, :explicit => true)
    end
  end
end