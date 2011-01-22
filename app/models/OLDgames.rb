class Game < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :team_one, :class_name => "Team", :foreign_key => "team_one_id"
  belongs_to :team_two, :class_name => "Team", :foreign_key => "team_two_id"
  belongs_to :winner, :class_name => "Team", :foreign_key => "winner_id"

#  belongs_to :author, :class_name => "Person", :foreign_key => "author_id"
end
