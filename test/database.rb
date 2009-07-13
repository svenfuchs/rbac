require 'activerecord'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(config['test'])

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.boolean :anonymous
end

ActiveRecord::Base.connection.create_table :sites do |t|
  t.string :title
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

class Site < ActiveRecord::Base
end

john = User.create!(:name => 'John')
jane = User.create!(:name => 'Jane')
jane = User.create!(:name => 'James', :anonymous => true)
blog = Site.create!(:title => 'Blog')
john.role_assignments.create!(:role => 'Static::Superuser', :context => blog)
