require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/database'

class ContextTest < Test::Unit::TestCase
  test "authorizing_roles_for raises when given action is nil" do
    assert_raises(ArgumentError) { content.role_context.authorizing_roles_for(nil) }
  end
  
  test "authorizing_roles_for falls back to permissions from root context" do
    with_default_permissions(:'edit content' => [:author]) do 
      assert_equal [:author], content.role_context.authorizing_roles_for('edit content')
    end
  end

  test "authorizing_roles_for uses object's permissions if given" do
    content = self.content
    content.permissions = { :'edit content' => [:superuser] }
    assert_equal [:superuser], content.role_context.authorizing_roles_for('edit content')
  end

  test "expand_roles_for" do
    content = self.content
    with_default_permissions(:'edit content' => [:user]) do
      content.permissions = { :'edit content' => [:moderator] }

      expected = %w(author-content-1 author-section-1
                    moderator-content-1 moderator-section-1
                    superuser user)
                    
                    # site/1/user/1/roles.js
                    # superuser
                    # moderator section-1
                    # author content-1
                    
      actual = content.role_context.expand_roles_for('edit content')
      assert_equal expected, actual.sort
    end
  end

  protected
  
    def content
      Content.find_by_title('content')
    end
end