class Game < ActiveRecord::Base
  belongs_to :tournament
  has_many :participants
  has_many :teams, :through => :participants

  def winner
    self.participants.find_by_winner(true)
  end

  def info
    self.winner.team.n + " " + self.original_odds.to_s + " " + self.adjusted_odds.to_s
  end

  def schedule_game(seeds, division)
    if self.participants.empty?
# FIND BY SEED AND DIVISION
      self.participants.create([:team => Team.find_by_seed_and_division(seeds[0],division), :winner => false])
      self.participants.create([:team => Team.find_by_seed_and_division(seeds[1],division), :winner => false])
    end
    self.update_attributes(:status => 'Scheduled')
  end

### THOUGHT THIS WOULD WORK FOR STORING ODDS...BUT I CAN JUST STORE IT ON THE GAME I THINK
  def odds=(chance)
    @odds = chance
  end

  def odds
    @odds ? @odds : 1
  end

  def scheduled?
    self.status == 'Scheduled' ? true : false 
  end

  def play_game
  unless(self.participants.empty?)
    teams = self.teams.order("seed")  ## NEED HIGH SEED FIRST -> SHOULD ALREADY BUIT JUST IN CASE
    user = self.tournament.user
logger.info("Teams: " + teams[0].n + " " + teams[1].n)
    up, over = 0, 0;
    ## GRAB USER TEAM
    user_team = user.team
    ## GRAB USER TAGS
## NEEDS TO CHANGE TO BRACKET TAGS!!!!! THEN YOU CAN HAVE MULTIPLE ANSWERS FOR DIFF BRACKETS
    #user_tags = user.tags 
    tournament_tags = self.tournament.tags.collect {|t| t.name}
    team_tags = user_team.tags.collect {|t| t.name}  ##METHOD THIS
    logger.info("Tourney tags: " + tournament_tags.to_s)
    logger.info("User Team tags: " + team_tags.to_s)
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

    self.update_attribute(:original_odds, Odds.game_odds(teams[0].seed,teams[1].seed))
    self.update_attribute(:adjusted_odds, (self.original_odds + over - up))
# CHANGE NAME OF .ods
    t = Game.ods(self.adjusted_odds) ? 1 : 0
    
    logger.info("Winning Team  = " + t.to_s)
    ## UPDATE WINNER BOOLEAN IN DB - HAVE TO USE PARTICIPANTS NOT TEAM HERE
    self.participants.find_by_team_id(teams[t]).update_attributes(:winner => true)
#    self.participants[t].update_attributes(:winner => true)
    self.update_attributes(:status => 'Played')
    return teams[t]  #WINNER

## RANDOMLY PICKS A TEAM...50/50
#    self.find(teams.sample).name
   end # ENDS UNLESS PARTICPANTS EMPTY
  end

  def self.ods(chance=0)
## RETURNS FALSE IF LESS THAN 1
    if chance > 0
      r = rand(chance)  # SETS R TO RANDOM INTEGER LESS THAN THE CHANCE NUMBER if 4 then it will be 0-3
      logger.info("Number: " + r.to_s + " Chance: " + chance.to_s)
      (r<1)             # SHOULD BE TRUE THE MAJORITY OF THE TIME
    else                # IF -negative then we need to switch the odds in favor of underdog
      r = rand(chance)  
      logger.info("-----------------------")
      if r<1 
      logger.info(r.to_s + " upset possible but didn't happen" )
        false # TOP SEED WON DESPITE THE ODDS
      else
      logger.info(r.to_s + " upset happened!" )
        true  # UPSET BECASUE OF THE 
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
