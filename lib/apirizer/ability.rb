require 'protector/cancan'

module Apirizer
  class Ability
    include CanCan::Ability

    def initialize(user)
      import_protector user
    end
  end
end
