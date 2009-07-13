module Rbac
  module Role
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

    def child_of?(role)
      self_and_parents.any? { |r| r == role }
    end

    # document :inherit option
    def granted_to?(user, options = {})
      !!user.role_assignments.detect do |assignment| 
        options[:explicit] ? self == assignment.role : self.child_of?(assignment.role)
      end
    end
  end
end