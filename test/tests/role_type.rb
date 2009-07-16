module Tests
  module RoleType
    include Rbac::Implementation::Static

    define_method "test: RoleType knows all available types" do
      assert_equal %w(anonymous author editor moderator superuser user), Rbac::RoleType.types.map(&:name).sort
    end

    # define_method "test: children" do
    #   assert_equal [], Superuser.children
    #   assert_equal [Superuser], Moderator.children
    #   assert_equal [Moderator], Author.children
    #   assert_equal [Author], User.children
    #   assert_equal [User], Anonymous.children
    # end
    # 
    # define_method "test: all_children" do
    #   assert_equal [], Superuser.all_children
    #   assert_equal [Superuser], Moderator.all_children
    #   assert_equal [Moderator, Superuser], Author.all_children
    #   assert_equal [Author, Moderator, Superuser], User.all_children
    #   assert_equal [User, Author, Moderator, Superuser], Anonymous.all_children
    # end
    # 
    # define_method "test: self_and_children" do
    #   assert_equal [Superuser], Superuser.self_and_children
    #   assert_equal [Moderator, Superuser], Moderator.self_and_children
    #   assert_equal [Author, Moderator, Superuser], Author.self_and_children
    #   assert_equal [User, Author, Moderator, Superuser], User.self_and_children
    #   assert_equal [Anonymous, User, Author, Moderator, Superuser], Anonymous.self_and_children
    # end
    # 
    # define_method "test: parent" do
    #   assert_equal Moderator, Superuser.parent
    #   assert_equal Author, Moderator.parent
    #   assert_equal User, Author.parent
    #   assert_equal Anonymous, User.parent
    #   assert_equal nil, Anonymous.parent
    # end
    # 
    # define_method "test: parents" do
    #   assert_equal [Moderator, Author, User, Anonymous], Superuser.parents
    #   assert_equal [Author, User, Anonymous], Moderator.parents
    #   assert_equal [User, Anonymous], Author.parents
    #   assert_equal [Anonymous], User.parents
    #   assert_equal [], Anonymous.parents
    # end
    # 
    # define_method "test: self_and_parents" do
    #   assert_equal [Superuser, Moderator, Author, User, Anonymous], Superuser.self_and_parents
    #   assert_equal [Moderator, Author, User, Anonymous], Moderator.self_and_parents
    #   assert_equal [Author, User, Anonymous], Author.self_and_parents
    #   assert_equal [User, Anonymous], User.self_and_parents
    #   assert_equal [Anonymous], Anonymous.self_and_parents
    # end

    define_method "test: RoleType#implementation" do
      assert_equal Rbac::Implementation::Static, Rbac::RoleType.implementation
    end

    define_method "test: RoleType#build" do
      assert_equal Superuser, Rbac::RoleType.build(:superuser)
    end
  
    define_method "test: RoleType#granted_to? returns true for assigned role and all parent roles" do
      assert_equal true,  Rbac::RoleType.build(:superuser).granted_to?(superuser)
      assert_equal true,  Rbac::RoleType.build(:moderator).granted_to?(superuser)
      assert_equal true,  Rbac::RoleType.build(:author).granted_to?(superuser, content)
      assert_equal true,  Rbac::RoleType.build(:user).granted_to?(superuser)
      assert_equal true,  Rbac::RoleType.build(:anonymous).granted_to?(superuser)

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
end
