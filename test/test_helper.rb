$:.unshift File.dirname(__FILE__) + '/../lib'

require 'rubygems'
require 'activerecord'
require 'activesupport'
require 'test/unit'
require 'rbac'

class Test::Unit::TestCase
  def self.test(name, &block)
    define_method("test: " + name, &block)
  end
  
  protected
  
    def superuser
      ::User.find_by_name('superuser')
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