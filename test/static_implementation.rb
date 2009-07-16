module Static
  class << self
    def build(name)
      const_get(name.to_s.camelize)
    end

    def all
      # constants.map { |name| const_get(name) }
      [Editor, Superuser, Moderator, Author, User, Anonymous]
    end
  end
  
  module Anonymous
    extend Rbac::RoleType

    class << self
      def requires_context?
        false
      end
      
      def parent
      end

      def children
        [User]
      end

      def granted_to?(user, context = nil, options = {})
        options[:explicit] ? false : true
      end
    end
  end

  module User
    extend Rbac::RoleType

    class << self
      def requires_context?
        false
      end
      
      def parent
        Anonymous
      end

      def children
        [Author]
      end

      def granted_to?(user, context = nil, options = {})
        options[:explicit] ? false : user.try(:registered?)
      end
    end
  end
  
  module Author
    extend Rbac::RoleType
    
    class << self
      def parent 
        User
      end
      
      def children
        [Moderator]
      end

      def granted_to?(user, context = nil, options = {})
        options[:explicit] ? false : context.respond_to?(:author) && context.author == user || super
      end
    end
  end
  
  module Moderator
    extend Rbac::RoleType
    
    class << self
      def parent 
        Author
      end
      
      def children
        [Superuser]
      end
    end
  end

  module Superuser
    extend Rbac::RoleType

    class << self
      def requires_context?
        false
      end
      
      def parent
        Moderator
      end

      def children
        []
      end
    end
  end
  
  module Editor
    extend Rbac::RoleType
    
    class << self
      def parent 
        User
      end
      
      def children
        [Superuser]
      end
    end
  end
end
