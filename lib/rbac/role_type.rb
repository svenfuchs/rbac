module Rbac
  module RoleType
    mattr_accessor :implementation

    class << self
      def build(*args)
        implementation.build(*args)
      end
    end
    
    def name
      super.split('::').last.underscore
    end
    
    def expand(object)
      expansion = [name]
      expansion += [object.class.to_s.underscore, object.id] if requires_context?
      expansion.join('-')
    end
    
    def requires_context?
      true
    end
    
    def self_and_parents
      [self] + parents
    end

    def parent
    end

    def parents
      [parent].compact + (parent ? parent.parents : [])
    end

    def self_and_children
      [self] + all_children
    end

    def children
      []
    end

    def all_children
      children + children.map(&:all_children).flatten
    end

    def parent_of?(name)
      self_and_children.any? { |type| type.name == name }
    end

    def include?(role, context = nil)
      parent_of?(role.name) && (!role.context || role.context.include?(context))
    end

    # document :explicit option
    def granted_to?(subject, context = nil, options = {})
      !!subject.roles.detect do |role|
        options[:explicit] ? self.name == role.name : self.include?(role, context)
      end
    end
  end
end