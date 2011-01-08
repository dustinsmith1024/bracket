class Team < ActiveRecord::Base


def self.random
  self.find_by_id(rand(Team.count) + 1)
end

def self.winner(teams, name=false)
  if name==false
#    if teams.include?(1)
#      return 1
#    end
    teams = teams.sort
logger.info(teams.to_json)
#    if teams[0] == 1
#     ## ALL ODDS FOR 1 vs matchups
#      if teams[1] == 2
#        teams.sample
#      end
#    end
    if teams[0] == 1
      t = case teams[1]
        when 1..2 then self.ods(1) ? 1 : 0
        when 3..4 then self.ods(2) ? 1 : 0
        when 5..9 then self.ods(5) ? 1 : 0
        when 10..12 then self.ods(8) ? 1 : 0
        when 13..16 then self.ods(90) ? 1 : 0
      end
    end
    if teams[0] == 2
      t = case teams[1]
        when 1..3 then self.ods(1) ? 1 : 0
        when 4..6 then self.ods(2) ? 1 : 0
        when 7..9 then self.ods(4) ? 1 : 0
        when 10..12 then self.ods(8) ? 1 : 0
        when 13..16 then self.ods(15) ? 1 : 0
      end
    end
    if teams[0] == 3
      t = case teams[1]
        when 1..2 then self.ods(4) ? 0 : 1
        when 3..4 then self.ods(1) ? 1 : 0
        when 5..7 then self.ods(3) ? 1 : 0
        when 8..10 then self.ods(5) ? 1 : 0
        when 11..16 then self.ods(10) ? 1 : 0
      end
    end
    if teams[0] == 4
      t = case teams[1]
        when 1..3 then self.ods(3) ? 0 : 1
        when 4..6 then self.ods(1) ? 1 : 0
        when 7..9 then self.ods(3) ? 1 : 0
        when 10..12 then self.ods(6) ? 1 : 0
        when 13..16 then self.ods(9) ? 1 : 0
      end
    end
    if teams[0] == 5
      t = case teams[1]
        when 1..2 then self.ods(4) ? 0 : 1
        when 3..4 then self.ods(2) ? 0 : 1
        when 5..7 then self.ods(1) ? 1 : 1
        when 8..10 then self.ods(6) ? 1 : 0
        when 11..16 then self.ods(9) ? 1 : 0
      end
    end
    if teams[0] == 6
      t = case teams[1]
        when 1..3 then self.ods(5) ? 0 : 1
        when 4..6 then self.ods(3) ? 0 : 1
        when 7..9 then self.ods(1) ? 1 : 0
        when 10..12 then self.ods(3) ? 1 : 0
        when 13..16 then self.ods(5) ? 1 : 0
      end
    end
    if teams[0] == 7
      t = case teams[1]
        when 1..3 then self.ods(5) ? 0 : 1
        when 4..6 then self.ods(3) ? 0 : 1
        when 7..9 then self.ods(1) ? 1 : 0
        when 10..12 then self.ods(3) ? 1 : 0
        when 13..16 then self.ods(5) ? 1 : 0
      end
    end
    if teams[0] >= 8
     ## ALL ODDS FOR 1 vs matchups
      t = case teams[1]
#        when 1..3 then self.ods(5) ? 0 : 1
#        when 4..7 then self.ods(3) ? 0 : 1
        when 8..9 then self.ods(1) ? 1 : 0
        when 10..12 then self.ods(3) ? 1 : 0
        when 13..16 then self.ods(5) ? 1 : 0
#      if teams[1] == 10
#        t = self.ods(3) ? 1 : 0
#      end
      end
    end
    logger.info(t)
    return teams[t]

#    teams.sample

  else
    self.find(teams.sample).name
  end
end

  def n
    return self.seed.to_s + ". " + self.name.to_s
  end

  def self.ods(chance=0)
## RETURNS FALSE IF LESS THAN 1
    (rand(chance)<1)
  end

def self.odds(t1, t2)
  if t1 > t2
    tmp = t2
    t2 = t1
    t1 = tmp
  end

  if t1 == t2
    return ".5".to_f
  end

  diff = t2 - t1
  if diff < 2
    return ".5".to_f
  end

  return t1/t2.to_f
end


end

