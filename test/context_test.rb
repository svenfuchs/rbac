require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/database'

class ContextTest < Test::Unit::TestCase
  test "authorizing_roles_for falls back to permissions from root context" do
    with_permissions(:'edit content' => [:author]) do 
      assert_equal [:author], content.role_context.authorizing_roles_for('edit content')
    end
  end

  test "authorizing_roles_for uses object's permissions if given" do
    content = self.content
    content.permissions = { :'edit content' => [:superuser] }
    assert_equal [:superuser], content.role_context.authorizing_roles_for('edit content')
  end
  
  protected
  
    def content
      Content.find_by_title('content')
    end
end