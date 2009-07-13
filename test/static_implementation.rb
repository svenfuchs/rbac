module Static
  module Anonymous
    extend Rbac::Role

    class << self
      def parent
      end

      def children
        [User]
      end

      def granted_to?(user, options = {})
        true
      end
    end
  end

  module User
    extend Rbac::Role

    class << self
      def parent
        Anonymous
      end

      def children
        [Superuser]
      end

      def granted_to?(user, options = {})
        user.try(:registered?)
      end
    end
  end

  module Superuser
    extend Rbac::Role

    class << self
      def parent
        User
      end

      def children
        []
      end
    end
  end
end
