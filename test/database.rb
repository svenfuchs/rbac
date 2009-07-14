config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(config['test'])

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.boolean :anonymous
end

ActiveRecord::Base.connection.create_table :sections do |t|
  t.string :title
end

ActiveRecord::Base.connection.create_table :contents do |t|
  t.references :section
  t.references :author
  t.string :title
  t.text :permissions
end

ActiveRecord::Base.connection.create_table :role_assignments do |t|
  t.references :user
  t.references :context, :polymorphic => true
  t.string :role
end

class RoleAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :context, :polymorphic => true
end

class User < ActiveRecord::Base
  include Rbac::HasRole
  has_many :role_assignments

  def registered?
    !new_record? && !anonymous?
  end
end

class Section < ActiveRecord::Base
  acts_as_role_context

  def include?(other)
    !!other
  end
end

class Content < ActiveRecord::Base
  acts_as_role_context :parent => Section, :parent_accessor => :owner

  belongs_to :section
  belongs_to :author, :class_name => 'User'
  
  def owner
    section
  end

  def include?(other)
    false
  end
end

superuser = User.create!(:name => 'superuser')
moderator = User.create!(:name => 'moderator')
author    = User.create!(:name => 'author')
user      = User.create!(:name => 'user')
anonymous = User.create!(:name => 'anonymous', :anonymous => true)

blog = Section.create!(:title => 'blog')
content = Content.create!(:title => 'content', :section => blog, :author => author)

superuser.role_assignments.create!(:role => 'Static::Superuser')
moderator.role_assignments.create!(:role => 'Static::Moderator', :context => blog)
