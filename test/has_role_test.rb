require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/static_implementation'
require File.dirname(__FILE__) + '/database'

Rbac::Role.implementation = Static

class HasRoleTest < Test::Unit::TestCase
  include Static
  
  test "User#has_role?" do
    assert_equal true, superuser.has_role?(:superuser)
    assert_equal true, superuser.has_role?(:user)
    assert_equal true, superuser.has_role?(:anonymous)
  
    assert_equal true, superuser.has_role?(Superuser)
    assert_equal true, superuser.has_role?(User)
    assert_equal true, superuser.has_role?(Anonymous)
  end
  
  test "User#has_explicit_role?" do
    assert_equal true,  superuser.has_explicit_role?(:superuser)
    assert_equal false, superuser.has_explicit_role?(:user)
    assert_equal false, superuser.has_explicit_role?(:anonymous)
  
    assert_equal false, user.has_explicit_role?(Superuser)
    assert_equal false, user.has_explicit_role?(User)
    assert_equal false, user.has_explicit_role?(Anonymous)
  end
end