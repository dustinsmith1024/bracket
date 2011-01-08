class Team < ActiveRecord::Base


def self.random
  self.find_by_id(rand(Team.count) + 1)
end

def self.winner(teams, name=false)
  if name==false
    teams.sample
  else
    self.find(teams.sample).name
  end
end

end
