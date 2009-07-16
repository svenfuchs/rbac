require File.dirname(__FILE__) + '/test_helper'

ActiveRecord::Base.connection.create_table :role_types do |t|
  t.references :parent
  t.string :name
  t.boolean :requires_context, :default => true
end

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

anonymous = RoleType.create!(:name => 'anonymous', :parent => nil,       :requires_context => false)
user      = RoleType.create!(:name => 'user',      :parent => anonymous, :requires_context => false)
author    = RoleType.create!(:name => 'author',    :parent => user)
moderator = RoleType.create!(:name => 'moderator', :parent => author)
superuser = RoleType.create!(:name => 'superuser', :parent => moderator, :requires_context => false)
editor    = RoleType.create!(:name => 'editor',    :parent => user)
