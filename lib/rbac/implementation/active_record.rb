require 'activerecord'

module Rbac
  module Implementation
    module ActiveRecord
      class RoleType < ::ActiveRecord::Base
        include Rbac::RoleType
        belongs_to :parent, :class_name => 'RoleType'

        class << self
          def build(name)
            find_by_name(name.to_s) || raise(Rbac::UndefinedRole.new(name))
          end
        end
        
        def requires_context?
          !!attributes['requires_context']
        end

        def children
          self.class.all(:conditions => { :parent_id => self.id })
        end

        def granted_to?(user, context = nil, options = {})
          return super unless ['anonymous', 'user', 'author'].include?(name)
          return false if options[:explicit]

          case name
          when 'anonymous'
            true
      		when 'user'
            user.try(:registered?)
          when 'author'
            context.respond_to?(:author) && context.author == user || super
          end
        end
      end
    end
  end
end

