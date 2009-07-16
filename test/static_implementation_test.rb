require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/database'


class HasRoleTest < Test::Unit::TestCase
  Rbac::RoleType.implementation = Rbac::Implementation::Static

  include Rbac::Implementation::Static
  include Tests::ActsAsRoleContext
  include Tests::Context
  include Tests::HasRole
  include Tests::RoleType
end