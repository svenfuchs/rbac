require File.dirname(__FILE__) + '/../test_helper'

class ImplementationStaticTest < Test::Unit::TestCase
  def setup
    Rbac::RoleType.implementation = Rbac::Implementation::Static
  end

  include Rbac::Implementation::Static
  include Tests::ActsAsRoleContext
  include Tests::Context
  include Tests::HasRole
  include Tests::RoleType
end