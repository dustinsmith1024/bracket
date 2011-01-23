class Tournament < ActiveRecord::Base
  has_many :games
  belongs_to :user
  has_and_belongs_to_many :tags

  def clear
    Participant.destroy self.games.collect{|g|g.participants}
    Game.destroy self.games
  end

  def build_games
  ## LOOPS ALL GAMES AND PLAYS THEM...PROLLY NEEDS A BETTER NAME
   (1..15).each do |game_number|
      game = self.games.find_or_create_by_number(game_number)

      if(game.status.nil?)
        game.schedule_game(whos_playing(game_number))
      end

      if(game.scheduled?)
        game.play_game
      end
     
    end  ## END GAME NUMBER LOOP
  end

  def whos_playing(game_number)
## MIGHT NEED A BETTER WAY TO DO THIS WHEN WE HAVE 68 GAMES....
    whos_playing = case game_number
      when 1 then [1,16]
      when 2 then [2,15]
      when 3 then [3,14]
      when 4 then [4,13]
      when 5 then [5,12]
      when 6 then [6,11]
      when 7 then [7,10]
      when 8 then [8,9]
      when 9 then [self.games[0].winner.team.seed,self.games[7].winner.team.seed]
      when 10 then [self.games[1].winner.team.seed,self.games[6].winner.team.seed]
      when 11 then [self.games[2].winner.team.seed,self.games[5].winner.team.seed]
      when 12 then [self.games[3].winner.team.seed,self.games[4].winner.team.seed]
      when 13 then [self.games[8].winner.team.seed,self.games[11].winner.team.seed]
      when 14 then [self.games[10].winner.team.seed,self.games[9].winner.team.seed]
      when 15 then [self.games[12].winner.team.seed,self.games[13].winner.team.seed]
    end
  end

  def play_games    
    self.games.each do |game_number|
      self.games.find_by_number(game_number).play_game
    end
  end

end
