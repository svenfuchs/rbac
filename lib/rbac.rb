require 'rbac/acts_as_role_context'
require 'rbac/context'
require 'rbac/has_role'
require 'rbac/role_type'

module Rbac
  class UndefinedRole < IndexError
    def initialize(name)
      "Could not find role named #{name}"
    end
  end

  class AuthorizingRoleNotFound < IndexError
    def initialize(context, action)
      "Could not find role(s) for #{action} (on: #{context.inspect})"
    end
  end
end