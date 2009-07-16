require 'rubygems'
require 'activerecord'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/../../../test/database.yml'))
ActiveRecord::Base.establish_connection(config['test'])


ActiveRecord::Base.connection.create_table :role_types do |t|
  t.references :parent
  t.string :name
  t.boolean :requires_context, :default => true
end

module Rbac
  module Implementation
    module ActiveRecord
      class RoleType < ActiveRecord::Base
        include Rbac::RoleType
        belongs_to :parent, :class_name => 'RoleType'

        class << self
          def build(name)
            find_by_name(name.to_s) || raise(Rbac::UndefinedRole.new(name))
          end
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

anonymous = Rbac::Implementation::RoleType.create!(:name => 'anonymous', :parent => nil,       :requires_context => false)
user      = Rbac::Implementation::RoleType.create!(:name => 'user',      :parent => anonymous, :requires_context => false)
author    = Rbac::Implementation::RoleType.create!(:name => 'author',    :parent => user)
moderator = Rbac::Implementation::RoleType.create!(:name => 'moderator', :parent => author)
superuser = Rbac::Implementation::RoleType.create!(:name => 'superuser', :parent => moderator, :requires_context => false)
editor    = Rbac::Implementation::RoleType.create!(:name => 'editor',    :parent => user)
