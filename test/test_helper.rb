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
end

# class User
# end

# module RoleTest
#   require 'singleton'
# 
#   class Superuser
#     include Singleton
#     include Rbac::Role
# 
#     def parents
#       self.class.ancestors.reject { |klass| klass == Object }
#     end
# 
#     def children
#       self.class.subclasses
#     end
#   end
# 
#   class User < Superuser
#   end
# 
#   class Anonymous < User
#   end
# end
