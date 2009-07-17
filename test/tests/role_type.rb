module Tests
  module RoleType
    # include Rbac::Implementation::Static

    define_method "test: RoleType knows all available types" do
      assert_equal %w(anonymous author editor moderator superuser user), Rbac::RoleType.types.map(&:name).sort
    end
    
    def method_missing(method, *args)
      return Rbac::RoleType.build(method.to_s.gsub(/_type/, '')) if method.to_s =~ /_type$/
      super
    end

    define_method "test: children" do
      assert_equal [], superuser_type.children.map(&:name)
      assert_equal ['superuser'], moderator_type.children.map(&:name)
      assert_equal ['moderator'], author_type.children.map(&:name)
      assert_equal ['author', 'editor'], user_type.children.map(&:name).sort
      assert_equal ['user'], anonymous_type.children.map(&:name)
    end
    
    define_method "test: all_children" do
      assert_equal [], superuser_type.all_children.map(&:name).sort
      assert_equal ['superuser'], moderator_type.all_children.map(&:name).sort
      assert_equal ['moderator', 'superuser'], author_type.all_children.map(&:name).sort
      assert_equal ['author', 'editor', 'moderator', 'superuser'], user_type.all_children.map(&:name).sort
      assert_equal ['author', 'editor', 'moderator', 'superuser', 'user'], anonymous_type.all_children.map(&:name).sort
    end

    define_method "test: self_and_children" do
      assert_equal ['superuser'], superuser_type.self_and_children.map(&:name).sort
      assert_equal ['moderator', 'superuser'], moderator_type.self_and_children.map(&:name).sort
      assert_equal ['author', 'moderator', 'superuser'], author_type.self_and_children.map(&:name).sort
      assert_equal ['author', 'editor', 'moderator', 'superuser', 'user'], user_type.self_and_children.map(&:name).sort
      assert_equal ['anonymous', 'author', 'editor', 'moderator', 'superuser', 'user'], anonymous_type.self_and_children.map(&:name).sort
    end

    define_method "test: parent" do
      assert_equal 'moderator', superuser_type.parent.name
      assert_equal 'author', moderator_type.parent.name
      assert_equal 'user', author_type.parent.name
      assert_equal 'user', editor_type.parent.name
      assert_equal 'anonymous', user_type.parent.name
      assert_equal nil, anonymous_type.parent
    end
  
    define_method "test: parents" do
      assert_equal ['anonymous', 'author', 'moderator', 'user'], superuser_type.parents.map(&:name).sort
      assert_equal ['anonymous', 'author', 'user'], moderator_type.parents.map(&:name).sort
      assert_equal ['anonymous', 'user'], author_type.parents.map(&:name).sort
      assert_equal ['anonymous', 'user'], editor_type.parents.map(&:name).sort
      assert_equal ['anonymous'], user_type.parents.map(&:name).sort
      assert_equal [], anonymous_type.parents.map(&:name).sort
    end

    define_method "test: self_and_parents" do
      assert_equal ['anonymous', 'author', 'moderator', 'superuser', 'user'], superuser_type.self_and_parents.map(&:name).sort
      assert_equal ['anonymous', 'author', 'moderator', 'user'], moderator_type.self_and_parents.map(&:name).sort
      assert_equal ['anonymous', 'author', 'user'], author_type.self_and_parents.map(&:name).sort
      assert_equal ['anonymous', 'editor', 'user'], editor_type.self_and_parents.map(&:name).sort
      assert_equal ['anonymous', 'user'], user_type.self_and_parents.map(&:name).sort
      assert_equal ['anonymous'], anonymous_type.self_and_parents.map(&:name).sort
    end

    define_method "test: RoleType#build returns an Rbac::RoleType" do
      %w(anonymous author editor moderator superuser user).each do |role_type|
        assert Rbac::RoleType.build(role_type.to_sym).respond_to?(:granted_to?)
      end
    end

    define_method "test: RoleType#granted_to? returns true for assigned role and all parent roles" do
      assert_equal true,  Rbac::RoleType.build(:superuser).granted_to?(superuser)
      assert_equal true,  Rbac::RoleType.build(:moderator).granted_to?(superuser)
      assert_equal true,  Rbac::RoleType.build(:author).granted_to?(superuser, content)
      assert_equal true,  Rbac::RoleType.build(:user).granted_to?(superuser)
      assert_equal true,  Rbac::RoleType.build(:anonymous).granted_to?(superuser)
    
      assert_equal false, superuser_type.granted_to?(moderator)
      assert_equal false, moderator_type.granted_to?(moderator)
      assert_equal true,  moderator_type.granted_to?(moderator, blog)
      assert_equal true,  author_type.granted_to?(moderator, content)
      assert_equal true,  user_type.granted_to?(moderator)
      assert_equal true,  anonymous_type.granted_to?(moderator )
    
      assert_equal false, superuser_type.granted_to?(author)
      assert_equal false, moderator_type.granted_to?(author)
      assert_equal true,  author_type.granted_to?(author, content)
      assert_equal true,  user_type.granted_to?(author)
      assert_equal true,  anonymous_type.granted_to?(author)
    
      assert_equal false, superuser_type.granted_to?(user)
      assert_equal false, moderator_type.granted_to?(user)
      assert_equal false, author_type.granted_to?(user, content)
      assert_equal true,  user_type.granted_to?(user)
      assert_equal true,  anonymous_type.granted_to?(user)
    
      assert_equal false, superuser_type.granted_to?(anonymous)
      assert_equal false, moderator_type.granted_to?(anonymous)
      assert_equal false, author_type.granted_to?(anonymous, content)
      assert_equal false, user_type.granted_to?(anonymous)
      assert_equal true,  anonymous_type.granted_to?(anonymous)
    end
  end
end
