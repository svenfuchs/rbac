require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/static_implementation'
require File.dirname(__FILE__) + '/database'

Rbac::Role.implementation = Static

class HasRoleTest < Test::Unit::TestCase
  include Static
  
  test "has_role? (single argument)" do
    assert_equal true, superuser.has_role?(:superuser)
    assert_equal true, superuser.has_role?(:user)
    assert_equal true, superuser.has_role?(:anonymous)
  
    assert_equal true, superuser.has_role?(Superuser)
    assert_equal true, superuser.has_role?(User)
    assert_equal true, superuser.has_role?(Anonymous)
  end
  
  test "has_role? (array argument)" do
    assert_equal false, moderator.has_role?([:superuser])
    assert_equal false, moderator.has_role?([:moderator, :superuser])
    assert_equal true,  moderator.has_role?([:moderator, :superuser], blog)
    assert_equal true,  moderator.has_role?([:author, :superuser], content)
  end
  
  test "has_explicit_role?" do
    assert_equal true,  superuser.has_explicit_role?(:superuser)
    assert_equal false, superuser.has_explicit_role?(:user)
    assert_equal false, superuser.has_explicit_role?(:anonymous)
  
    assert_equal false, user.has_explicit_role?(Superuser)
    assert_equal false, user.has_explicit_role?(User)
    assert_equal false, user.has_explicit_role?(Anonymous)
  end
  
  test "has_permission? raises Rbac::AuthorizingRoleNotFound exception when authorizing role can not be found" do
    assert_raises(Rbac::AuthorizingRoleNotFound) { superuser.has_permission?('drink redbull', Rbac::Context.root) }
  end
  
  test "has_permission? returns true when the user has a role that authorizes the action" do
    with_permissions(:'edit content' => [:author]) do 
      assert_equal true, superuser.has_permission?('edit content', Rbac::Context.root)
    end
  end
end