require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/static_implementation'
require File.dirname(__FILE__) + '/database'

Rbac::Role.implementation = Static

class StaticHiercharchyTest < Test::Unit::TestCase
  include Static

  test "children" do
    assert_equal [], Superuser.children
    assert_equal [Superuser], User.children
    assert_equal [User], Anonymous.children
  end

  test "all_children" do
    assert_equal [], Superuser.all_children
    assert_equal [Superuser], User.all_children
    assert_equal [User, Superuser], Anonymous.all_children
  end

  test "self_and_children" do
    assert_equal [Superuser], Superuser.self_and_children
    assert_equal [User, Superuser], User.self_and_children
    assert_equal [Anonymous, User, Superuser], Anonymous.self_and_children
  end

  test "parent" do
    assert_equal User, Superuser.parent
    assert_equal Anonymous, User.parent
    assert_equal nil, Anonymous.parent
  end

  test "parents" do
    assert_equal [User, Anonymous], Superuser.parents
    assert_equal [Anonymous], User.parents
    assert_equal [], Anonymous.parents
  end

  test "self_and_parents" do
    assert_equal [Superuser, User, Anonymous], Superuser.self_and_parents
    assert_equal [User, Anonymous], User.self_and_parents
    assert_equal [Anonymous], Anonymous.self_and_parents
  end

  test "Role#implementation" do
    assert_equal Static, Rbac::Role.implementation
  end

  test "Role#build" do
    assert_equal Superuser, Rbac::Role.build(:superuser)
  end

  test "Role#granted_to? returns true for explicitly assigned role and all parent roles if the :inherit option isn't passed" do
    john = ::User.find_by_name('John')
    assert_equal true, Superuser.granted_to?(john)
    assert_equal true, User.granted_to?(john)
    assert_equal true, Anonymous.granted_to?(john)

    jane = ::User.find_by_name('Jane')
    assert_equal false, Superuser.granted_to?(jane)
    assert_equal true, User.granted_to?(jane)
    assert_equal true, Anonymous.granted_to?(jane)

    james = ::User.find_by_name('James')
    assert_equal false, Superuser.granted_to?(james)
    assert_equal false, User.granted_to?(james)
    assert_equal true, Anonymous.granted_to?(james)
  end

  test "User#has_role?" do
    john = ::User.find_by_name('John')
    assert_equal true, john.has_role?(:superuser)
    assert_equal true, john.has_role?(:user)
    assert_equal true, john.has_role?(:anonymous)

    assert_equal true, john.has_role?(Superuser)
    assert_equal true, john.has_role?(User)
    assert_equal true, john.has_role?(Anonymous)
  end

  test "User#has_explicit_role?" do
    john = ::User.find_by_name('John')
    jane = ::User.find_by_name('Jane')

    assert_equal true,  john.has_explicit_role?(:superuser)
    assert_equal false, john.has_explicit_role?(:user)
    assert_equal false, john.has_explicit_role?(:anonymous)

    assert_equal false, jane.has_explicit_role?(Superuser)
    assert_equal false, jane.has_explicit_role?(User)
    assert_equal false, jane.has_explicit_role?(Anonymous)
  end
end





