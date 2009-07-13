require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/static_implementation'
require File.dirname(__FILE__) + '/database'

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

  test "granted_to? returns true for explicitly assigned role and all parent roles if the :inherit option isn't passed" do
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

  # test "granted_to? returns false for an explicitely assigned role's parent roles if the :inherit option is set to false" do
  #   john = ::User.find_by_name('John')
  #   # Test doesn't make any sense 8-}
  #   assert_equal false, User.granted_to?(john, :explicit => true)
  #   assert_equal false, Anonymous.granted_to?(john, :explicit => true)
  # end
end