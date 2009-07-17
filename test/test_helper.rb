$: << File.dirname(__FILE__) + '/../lib'

require 'rubygems'
require 'activerecord'
require 'activesupport'
require 'test/unit'
require 'rbac'

require 'rbac/implementation/static'
require 'rbac/implementation/active_record'

require File.dirname(__FILE__) + '/database'
Dir[File.dirname(__FILE__) + '/tests/*.rb'].each do |filename|
  require filename
end


class Test::Unit::TestCase
  def self.test(name, &block)
    define_method("test: " + name, &block)
  end

  def with_default_permissions(permissions_map={}, &block)
    original_permissions = Rbac::Context.default_permissions
    Rbac::Context.default_permissions = permissions_map
    yield
    Rbac::Context.default_permissions = original_permissions
  end
  
  protected
  
    def superuser
      ::User.find_by_name('superuser')
    end
    
    def editor
      ::User.find_by_name('editor')
    end

    def moderator
      ::User.find_by_name('moderator')
    end

    def author
      ::User.find_by_name('author')
    end

    def user
      ::User.find_by_name('user')
    end

    def anonymous
      ::User.find_by_name('anonymous')
    end

    def blog
      ::Section.find_by_title('blog')
    end
    
    def content
      ::Content.find_by_title('content')
    end
end

module TestHelper
  def self.test(name, &block)
    define_method("test: " + name, &block)
  end
end