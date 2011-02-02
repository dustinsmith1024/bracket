class Team < ActiveRecord::Base
  default_scope order('division, seed')
  has_and_belongs_to_many :tags
  has_many :winners, :class_name => 'Game', :foreign_key => 'winner_id'
  has_many :team_ones, :class_name => 'Game', :foreign_key => 'team_one_id'
  has_many :team_twos, :class_name => 'Game', :foreign_key => 'team_two_id'
  has_many :users
  has_many :participants
  has_many :games, :through => :participants
#has_many :purchases, :class_name => 'Sale', :foreign_key => 'buyer_id'
  validates_uniqueness_of :seed, :scope => :division

def self.random
  self.find_by_id(rand(Team.count) + 1)
end

def self.winner(teams, user, name=false)
  if name==false
    up = 0;
    over = 0;
    teams = teams.sort
## FILL IN FROM USER -> MY TEAM
#    user_team = Team.find_by_name("Iowa")
    user_team = user.team
## FILL IN FROM USER -> TAGS EVENTUALLY, WHICH ARE FED FROM QUESTIONS!
#    user_tags = %w{Blue Yellow Bird}
#    user_tags << "Bird - Real"  ## PUSH ON ONE WITH SPACES...
    user_tags = user.tags
    team_tags = user_team.tags.collect {|t| t.name}
    logger.info(user_tags)
    logger.info(team_tags)
    tmp_tags = []
    teams.each_with_index do |t,index|
## PUSH TAG NAMES ONTO AN ARRAY
      tmp_tags[index] ||= Team.find_by_seed(t).tags.collect{|t|t.name}
      if index == 0
## IF THE FIRST TEAM THEN INCREASE THE OVER VAR TO HELP THE BEST SEED WIN
        user_tags.each do |tag|
## LOOP THROUGH ALL TAGS TO SEE IF THEY MATCH
          if tmp_tags[index].include?(tag)
            over += 2
          end
        end
      else
## IF THE SECOND TEAM THEN INCREASE THE UP VAR TO MAKE UNDERDOGS WIN
        user_tags.each do |tag|
          if tmp_tags[index].include?(tag)
            up += 2
          end
        end
      end
    end

    #team_plus = 10
    if Team.find(teams[0]) == user_team
      over += 5
      logger.info("iowwwaaa1" + over.to_s)
    elsif Team.find(teams[1]) == user_team
      up += 10
      logger.info("iowwwaaaaa2" + up.to_s)
    end
#    if teams[0] == 1
#     ## ALL ODDS FOR 1 vs matchups
#      if teams[1] == 2
#        teams.sample
#      end
#    end
#    SWITCH CASES TO FIND SECOND TEAM THEN PASS ODDS
#    IF 1-4 ODDS PASS A 4 TO .ods
#    THE TEAM THAT SHOULD WIN SHOULD BE FIRST AFTER ?
logger.info("OVER: " + over.to_s + " UP: " + up.to_s)
    if teams[0] == 1
      t = case teams[1]
        when 1..2 then self.ods(1 + over - up) ? 1 : 0
        when 3..4 then self.ods(2 + over - up) ? 1 : 0
        when 5..9 then self.ods(5 + over - up) ? 1 : 0
        when 10..12 then self.ods(8 + over - up) ? 1 : 0
        when 13..16 then self.ods(90 + over - up) ? 1 : 0
      end
    end
    if teams[0] == 2
      t = case teams[1]
        when 1..3 then self.ods(1 + over - up) ? 1 : 0
        when 4..6 then self.ods(2 + over - up) ? 1 : 0
        when 7..9 then self.ods(4 + over - up) ? 1 : 0
        when 10..12 then self.ods(8 + over - up) ? 1 : 0
        when 13..16 then self.ods(15 + over - up) ? 1 : 0
      end
    end
    if teams[0] == 3
      t = case teams[1]
        when 1..2 then self.ods(4 + over - up) ? 0 : 1
        when 3..4 then self.ods(1 + over - up) ? 1 : 0
        when 5..7 then self.ods(3 + over - up) ? 1 : 0
        when 8..10 then self.ods(5 + over - up) ? 1 : 0
        when 11..16 then self.ods(10 + over - up) ? 1 : 0
      end
    end
    if teams[0] == 4
      t = case teams[1]
        when 1..3 then self.ods(3 + over - up) ? 0 : 1
        when 4..6 then self.ods(1 + over - up) ? 1 : 0
        when 7..9 then self.ods(3 + over - up) ? 1 : 0
        when 10..12 then self.ods(6 + over - up) ? 1 : 0
        when 13..16 then self.ods(9 + over - up) ? 1 : 0
      end
    end
    if teams[0] == 5
      t = case teams[1]
        when 1..2 then self.ods(4 + over - up) ? 0 : 1
        when 3..4 then self.ods(2 + over - up) ? 0 : 1
        when 5..7 then self.ods(1 + over - up) ? 1 : 1
        when 8..10 then self.ods(6 + over - up) ? 1 : 0
        when 11..16 then self.ods(9 + over - up) ? 1 : 0
      end
    end
    if teams[0] == 6
      t = case teams[1]
        when 1..3 then self.ods(5 + over - up) ? 0 : 1
        when 4..6 then self.ods(3 + over - up) ? 0 : 1
        when 7..9 then self.ods(1 + over - up) ? 1 : 0
        when 10..12 then self.ods(3 + over - up) ? 1 : 0
        when 13..16 then self.ods(5 + over - up) ? 1 : 0
      end
    end
    if teams[0] == 7
      t = case teams[1]
        when 1..3 then self.ods(5 + over - up) ? 0 : 1
        when 4..6 then self.ods(3 + over - up) ? 0 : 1
        when 7..9 then self.ods(1 + over - up) ? 1 : 0
        when 10..12 then self.ods(3 + over - up) ? 1 : 0
        when 13..16 then self.ods(5 + over - up) ? 1 : 0
      end
    end
    if teams[0] >= 8
     ## ALL ODDS FOR 1 vs matchups
      t = case teams[1]
#        when 1..3 then self.ods(5) ? 0 : 1
#        when 4..7 then self.ods(3) ? 0 : 1
        when 8..9 then self.ods(1 + over - up) ? 1 : 0
        when 10..12 then self.ods(3 + over - up) ? 1 : 0
        when 13..16 then self.ods(5 + over - up) ? 1 : 0
#      if teams[1] == 10
#        t = self.ods(3) ? 1 : 0
#      end
      end
    end
    logger.info(t)
    return teams[t]

  else
## RANDOMLY PICKS A TEAM...50/50
    self.find(teams.sample).name
  end
end

  def n
    if self.short_name.nil?
      return self.seed.to_s + ". " + self.name.to_s
    else
      return self.seed.to_s + ". " + self.short_name.to_s
    end
  end

  def self.ods(chance=0)
## RETURNS FALSE IF LESS THAN 1
# IF - then we need to switch the odds somewhow...
    if chance > 0

      r = rand(chance)
logger.info(r)
# pp (r)
      (r<1)
    else
      r = rand(chance)
logger.info(r.to_s + " upset possible" )
# pp (r)
      if r<1
        false
      else
        true
      end
    end
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

