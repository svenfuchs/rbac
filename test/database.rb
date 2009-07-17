config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(config['test'])

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.boolean :anonymous
end

ActiveRecord::Base.connection.create_table :sections do |t|
  t.string :title
  t.text :permissions
end

ActiveRecord::Base.connection.create_table :contents do |t|
  t.references :section
  t.references :author
  t.string :title
  t.text :permissions
end

ActiveRecord::Base.connection.create_table :roles do |t|
  t.references :user
  t.references :context, :polymorphic => true
  t.string :name
end

ActiveRecord::Base.connection.create_table :role_types do |t|
  t.references :parent
  t.string :name
  t.boolean :requires_context, :default => true
end

class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :context, :polymorphic => true
end

class User < ActiveRecord::Base
  include Rbac::HasRole
  has_many :roles

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
editor    = User.create!(:name => 'editor')
moderator = User.create!(:name => 'moderator')
author    = User.create!(:name => 'author')
user      = User.create!(:name => 'user')
anonymous = User.create!(:name => 'anonymous', :anonymous => true)

blog = Section.create!(:title => 'blog')
content = Content.create!(:title => 'content', :section => blog, :author => author)

superuser.roles.create!(:name => 'superuser')
editor.roles.create!(:name => 'editor')
moderator.roles.create!(:name => 'moderator', :context => blog)


anonymous_type = Rbac::Implementation::ActiveRecord::RoleType.create!(:name => 'anonymous', :parent => nil,            :requires_context => false)
user_type      = Rbac::Implementation::ActiveRecord::RoleType.create!(:name => 'user',      :parent => anonymous_type, :requires_context => false)
author_type    = Rbac::Implementation::ActiveRecord::RoleType.create!(:name => 'author',    :parent => user_type,      :requires_context => true)
moderator_type = Rbac::Implementation::ActiveRecord::RoleType.create!(:name => 'moderator', :parent => author_type,    :requires_context => true)
superuser_type = Rbac::Implementation::ActiveRecord::RoleType.create!(:name => 'superuser', :parent => moderator_type, :requires_context => false)
editor_type    = Rbac::Implementation::ActiveRecord::RoleType.create!(:name => 'editor',    :parent => user_type,      :requires_context => true)
