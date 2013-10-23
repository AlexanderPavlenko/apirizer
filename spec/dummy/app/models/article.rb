class Article < ActiveRecord::Base
  protect do |user|
    can :read, :title
    can :update, :title
    can :create, :title
    can :create, content: lambda{|s| s.include? 'interesting' }
  end
end
