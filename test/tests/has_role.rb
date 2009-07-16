module Tests
  module HasRole
    define_method "test: has_role? (single argument)" do
      assert_equal true, superuser.has_role?(:superuser)
      assert_equal true, superuser.has_role?(:user)
      assert_equal true, superuser.has_role?(:anonymous)
    end
  
    define_method "test: has_role? (array argument)" do
      assert_equal false, moderator.has_role?([:superuser])
      assert_equal false, moderator.has_role?([:moderator, :superuser])
      assert_equal true,  moderator.has_role?([:moderator, :superuser], blog)
      assert_equal true,  moderator.has_role?([:author, :superuser], content)
    end
  
    define_method "test: has_explicit_role?" do
      assert_equal true,  superuser.has_explicit_role?(:superuser)
      assert_equal false, superuser.has_explicit_role?(:user)
      assert_equal false, superuser.has_explicit_role?(:anonymous)
    end
  
    define_method "test: has_permission? raises Rbac::AuthorizingRoleNotFound exception when authorizing role can not be found" do
      assert_raises(Rbac::AuthorizingRoleNotFound) { superuser.has_permission?('drink redbull', Rbac::Context.root) }
    end
  
    define_method "test: has_permission? returns true when the user has a role that authorizes the action" do
      with_default_permissions(:'edit content' => [:author]) do 
        assert_equal true, superuser.has_permission?('edit content', Rbac::Context.root)
      end
    end
  
    define_method "test: has_permission? returns true for authorized roles that aren't part of the same role hierarchy" do
      with_default_permissions(:'edit content' => [:editor]) do
        content = self.content
        content.section.permissions = { :'edit content' => [:moderator] }
        assert_equal true, moderator.has_permission?('edit content', content)
        assert_equal true, editor.has_permission?('edit content', content)
      end
    end
  end
end