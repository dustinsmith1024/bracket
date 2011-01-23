class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :participants
  has_many :teams, :through => :participants

  def winner
    self.participants.find_by_winner(true)
  end

  def schedule_game(seeds)
    if self.participants.empty?
      self.participants.create([:team => Team.find_by_seed(seeds[0]), :winner => false])
      self.participants.create([:team => Team.find_by_seed(seeds[1]), :winner => false])
    end
    self.update_attributes(:status => 'Scheduled')
  end

  def scheduled?
    self.status == 'Scheduled' ? true : false 
  end

  def play_game
  unless(self.participants.empty?)
    teams = self.teams.order("seed")  ## NEED HIGH SEED FIRST -> SHOULD ALREADY BUIT JUST IN CASE
    user = self.tournament.user
  
    up, over = 0, 0;
    ## GRAB USER TEAM
    user_team = user.team
    ## GRAB USER TAGS
## NEEDS TO CHANGE TO BRACKET TAGS!!!!! THEN YOU CAN HAVE MULTIPLE ANSWERS FOR DIFF BRACKETS
    #user_tags = user.tags 
    tournament_tags = tournament.tags.collect {|t| t.name}
    team_tags = user_team.tags.collect {|t| t.name}  ##METHOD THIS
    logger.info(tournament_tags)
    logger.info(team_tags)
    tmp_tags = []
    teams.each_with_index do |team,index|
    ## PUSH TAG NAMES ONTO AN ARRAY AND DEFINE IF NIL
      tmp_tags[index] ||= team.tags.collect{|t|t.name}
      if index == 0  ## IF THE FIRST TEAM THEN INCREASE THE OVER VAR TO HELP THE BEST SEED WIN
        tournament_tags.each do |tag| ## LOOP THROUGH ALL TAGS TO SEE IF THEY MATCH
#logger.info("LOOK FOR THIS TAG ->>>>> " + tag)
          if tmp_tags[index].include?(tag)
#logger.info("FOUND A TAG ->>>>> " + tag)
            over += 2  ## GLOBAL VAR THIS EVENTUALLY
          end
        end
      else
      ## IF THE SECOND TEAM THEN INCREASE THE UP VAR TO MAKE UNDERDOGS WIN
        tournament_tags.each do |tag|
#logger.info("LOOK FOR THIS TAG ->>>>> " + tag)
          if tmp_tags[index].include?(tag)
#logger.info("FOUND A TAG ->>>>> " + tag)
            up += 2
          end
        end
      end
    end
#logger.info("Over #{over.to_s} - Up #{up.to_s}")
    ## UPS THE ODD IF YOUR TEAM IS SELECTED
    ## NOT SURE IF ITS RIGHT TO INCREASE UPSETS MORE OR NOT...TOP SEED ALREADY HAS ADVANTAGE THOUGH
    if teams[0] == user_team
      over += 5
      logger.info("User Team Found - Increase odds to :" + over.to_s)
    elsif teams[1] == user_team
      up += 10
      logger.info("User Team Found - Increase odds to :" + up.to_s)
    end

    logger.info("OVER: " + over.to_s + " UP: " + up.to_s)
    if teams[0].seed == 1
      t = case teams[1].seed
        when 1..2 then Game.ods(1 + over - up) ? 1 : 0
        when 3..4 then Game.ods(2 + over - up) ? 1 : 0
        when 5..9 then Game.ods(5 + over - up) ? 1 : 0
        when 10..12 then Game.ods(8 + over - up) ? 1 : 0
        when 13..16 then Game.ods(90 + over - up) ? 1 : 0
      end
    end
    if teams[0].seed == 2
      t = case teams[1].seed
        when 1..3 then Game.ods(1 + over - up) ? 1 : 0
        when 4..6 then Game.ods(2 + over - up) ? 1 : 0
        when 7..9 then Game.ods(4 + over - up) ? 1 : 0
        when 10..12 then Game.ods(8 + over - up) ? 1 : 0
        when 13..16 then Game.ods(15 + over - up) ? 1 : 0
      end
    end
    if teams[0].seed == 3
      t = case teams[1].seed
        when 1..2 then Game.ods(4 + over - up) ? 0 : 1
        when 3..4 then Game.ods(1 + over - up) ? 1 : 0
        when 5..7 then Game.ods(3 + over - up) ? 1 : 0
        when 8..10 then Game.ods(5 + over - up) ? 1 : 0
        when 11..16 then Game.ods(10 + over - up) ? 1 : 0
      end
    end
    if teams[0].seed == 4
      t = case teams[1].seed
        when 1..3 then Game.ods(3 + over - up) ? 0 : 1
        when 4..6 then Game.ods(1 + over - up) ? 1 : 0
        when 7..9 then Game.ods(3 + over - up) ? 1 : 0
        when 10..12 then Game.ods(6 + over - up) ? 1 : 0
        when 13..16 then Game.ods(9 + over - up) ? 1 : 0
      end
    end
    if teams[0].seed == 5
      t = case teams[1].seed
        when 1..2 then Game.ods(4 + over - up) ? 0 : 1
        when 3..4 then Game.ods(2 + over - up) ? 0 : 1
        when 5..7 then Game.ods(1 + over - up) ? 1 : 1
        when 8..10 then Game.ods(6 + over - up) ? 1 : 0
        when 11..16 then Game.ods(9 + over - up) ? 1 : 0
      end
    end
    if teams[0].seed == 6
      t = case teams[1].seed
        when 1..3 then Game.ods(5 + over - up) ? 0 : 1
        when 4..6 then Game.ods(3 + over - up) ? 0 : 1
        when 7..9 then Game.ods(1 + over - up) ? 1 : 0
        when 10..12 then Game.ods(3 + over - up) ? 1 : 0
        when 13..16 then Game.ods(5 + over - up) ? 1 : 0
      end
    end
    if teams[0].seed == 7
      t = case teams[1].seed
        when 1..3 then Game.ods(5 + over - up) ? 0 : 1
        when 4..6 then Game.ods(3 + over - up) ? 0 : 1
        when 7..9 then Game.ods(1 + over - up) ? 1 : 0
        when 10..12 then Game.ods(3 + over - up) ? 1 : 0
        when 13..16 then Game.ods(5 + over - up) ? 1 : 0
      end
    end
    if teams[0].seed >= 8
     ## ALL ODDS FOR 1 vs matchups
     ## ALL OTHER MATCHUPS SHOULD HAVE BEEN HANDELED ABOVE
      t = case teams[1].seed
        when 8..9 then Game.ods(1 + over - up) ? 1 : 0
        when 10..12 then Game.ods(3 + over - up) ? 1 : 0
        when 13..16 then Game.ods(5 + over - up) ? 1 : 0
      end
    end
    logger.info("Winning Seed = " + t.to_s)
    ## UPDATE WINNER BOOLEAN IN DB - HAVE TO USE PARTICIPANTS NOT TEAM HERE
    self.participants[t].update_attributes(:winner => true)
    self.update_attributes(:status => 'Played')
    return teams[t]  #WINNER

## RANDOMLY PICKS A TEAM...50/50
#    self.find(teams.sample).name
   end # ENDS UNLESS PARTICPANTS EMPTY
  end

  def self.ods(chance=0)
## RETURNS FALSE IF LESS THAN 1
# IF - then we need to switch the odds somewhow...
    if chance > 0
      r = rand(chance)
      logger.info(r)
      (r<1)
    else
      r = rand(chance)
      logger.info(r.to_s + " upset possible" )
      if r<1
        false
      else
        true
      end
    end
  end

  def self.odds(t1, t2)
## ORIGINAL ODDS
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
