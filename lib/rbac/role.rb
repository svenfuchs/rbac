module Rbac
  module Role
    mattr_accessor :implementation

    class << self
      def build(*args)
        implementation.build(*args)
      end
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

    def ==(other)
      other.is_a?(String) ? self.name == other : super
    end

    def parent_of?(role)
      self_and_children.any? { |r| r == role }
    end

    def include?(assignment, context = nil)
      parent_of?(assignment.role) && (!assignment.context || assignment.context.include?(context))
    end

    # document :explicit option
    def granted_to?(user, context = nil, options = {})
      !!user.role_assignments.detect do |assignment|
        options[:explicit] ? self == assignment.role : self.include?(assignment, context)
      end
    end
  end
end