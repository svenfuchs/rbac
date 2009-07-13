module Rbac
  module HasRole
    def has_permission?(action, context)
      required_role = context.required_role_for(action)
      has_role?(required_role, context)
    end

    def has_role?(role, context)
      # inherit = options.delete(:inherit)
      # role = Rbac::Role.build role, options unless role.is_a? Rbac::Role::Base
      # role.granted_to? self, options.merge(:inherit => inherit||true)
    end

    def has_exact_role?(name, context)
      # role = Rbac::Role.build(name, object)
      # role.exactly_granted_to? self
    end
  end
end

# class Adva::Role < ActiveRecord::Base
#   include Rbac::Role
# 
#   attr :name
# 
#   belongs_to :parent, :class_name => 'Rbac::Role'
# 
#   def self.inherited(child)
#     Superuser.includes << child.to_s.to_sym
#   end
# end
# 
# class Adva::RoleAssignment < ActiveRecord::Base
#   # ...
# end
# 
# module Rbac::Role
#   def parent
#     raise "you have to implement this"
#   end
# end
# 
# 
# class Superuser
# #  self.includes = [:admin, :moderator, ...]
# end
# 
