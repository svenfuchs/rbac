require File.dirname(__FILE__) + '/../test_helper'

class ImplementationActiveRecordTest < Test::Unit::TestCase
  def setup
    Rbac::RoleType.implementation = Rbac::Implementation::ActiveRecord::RoleType
  end

  # include Tests::ActsAsRoleContext
  include Tests::Context
  include Tests::HasRole
  include Tests::RoleType
  
  # def test_foo
  #   p superuser_type.minions
  # end
end