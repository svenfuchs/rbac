require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/static_implementation'
require File.dirname(__FILE__) + '/database'

Rbac::Role.implementation = Static

class RoleTest < Test::Unit::TestCase
  include Static

  test "children" do
    assert_equal [], Superuser.children
    assert_equal [Superuser], Moderator.children
    assert_equal [Moderator], Author.children
    assert_equal [Author], User.children
    assert_equal [User], Anonymous.children
  end

  test "all_children" do
    assert_equal [], Superuser.all_children
    assert_equal [Superuser], Moderator.all_children
    assert_equal [Moderator, Superuser], Author.all_children
    assert_equal [Author, Moderator, Superuser], User.all_children
    assert_equal [User, Author, Moderator, Superuser], Anonymous.all_children
  end

  test "self_and_children" do
    assert_equal [Superuser], Superuser.self_and_children
    assert_equal [Moderator, Superuser], Moderator.self_and_children
    assert_equal [Author, Moderator, Superuser], Author.self_and_children
    assert_equal [User, Author, Moderator, Superuser], User.self_and_children
    assert_equal [Anonymous, User, Author, Moderator, Superuser], Anonymous.self_and_children
  end

  test "parent" do
    assert_equal Moderator, Superuser.parent
    assert_equal Author, Moderator.parent
    assert_equal User, Author.parent
    assert_equal Anonymous, User.parent
    assert_equal nil, Anonymous.parent
  end

  test "parents" do
    assert_equal [Moderator, Author, User, Anonymous], Superuser.parents
    assert_equal [Author, User, Anonymous], Moderator.parents
    assert_equal [User, Anonymous], Author.parents
    assert_equal [Anonymous], User.parents
    assert_equal [], Anonymous.parents
  end

  test "self_and_parents" do
    assert_equal [Superuser, Moderator, Author, User, Anonymous], Superuser.self_and_parents
    assert_equal [Moderator, Author, User, Anonymous], Moderator.self_and_parents
    assert_equal [Author, User, Anonymous], Author.self_and_parents
    assert_equal [User, Anonymous], User.self_and_parents
    assert_equal [Anonymous], Anonymous.self_and_parents
  end

  test "Role#implementation" do
    assert_equal Static, Rbac::Role.implementation
  end

  test "Role#build" do
    assert_equal Superuser, Rbac::Role.build(:superuser)
  end
  
  test "Role#granted_to? returns true for assigned role and all parent roles" do
    assert_equal true,  Superuser.granted_to?(superuser)
    assert_equal true,  Moderator.granted_to?(superuser)
    assert_equal true,  Author.granted_to?(superuser, content)
    assert_equal true,  User.granted_to?(superuser)
    assert_equal true,  Anonymous.granted_to?(superuser)

    assert_equal false, Superuser.granted_to?(moderator)
    assert_equal false, Moderator.granted_to?(moderator)
    assert_equal true,  Moderator.granted_to?(moderator, blog)
    assert_equal true,  Author.granted_to?(moderator, content)
    assert_equal true,  User.granted_to?(moderator)
    assert_equal true,  Anonymous.granted_to?(moderator )
    
    assert_equal false, Superuser.granted_to?(author)
    assert_equal false, Moderator.granted_to?(author)
    assert_equal true,  Author.granted_to?(author, content)
    assert_equal true,  User.granted_to?(author)
    assert_equal true,  Anonymous.granted_to?(author)

    assert_equal false, Superuser.granted_to?(user)
    assert_equal false, Moderator.granted_to?(user)
    assert_equal false, Author.granted_to?(user, content)
    assert_equal true,  User.granted_to?(user)
    assert_equal true,  Anonymous.granted_to?(user)

    assert_equal false, Superuser.granted_to?(anonymous)
    assert_equal false, Moderator.granted_to?(anonymous)
    assert_equal false, Author.granted_to?(anonymous, content)
    assert_equal false, User.granted_to?(anonymous)
    assert_equal true,  Anonymous.granted_to?(anonymous)
  end
end





