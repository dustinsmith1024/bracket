class Tournament < ActiveRecord::Base
  has_many :games
  belongs_to :user
  has_and_belongs_to_many :tags

  def clear
    Participant.destroy self.games.collect{|g|g.participants}
    Game.destroy self.games
  end

  def tag_by_kind(kind)
    if self.tags.empty?
      nil
    else
      self.tags.find_by_kind(kind).id
    end
  end

  def build_games
  ## LOOPS ALL GAMES AND PLAYS THEM...PROLLY NEEDS A BETTER NAME

   (0..66).each do |game_number|

      division = case game_number
        when 0..15 then "East"
        when 16..31 then "Midwest"
        when 32..47 then "South"
        when 48..63 then "West"
        when 64..66 then "Final Four"  #WHAT TO DO HERE...
      end

      division_two = nil

      game = self.games.find_or_create_by_number(game_number)

      if(game.status.nil?)
        if game_number < 64
          game.schedule_game(whos_playing(game_number),division)
        elsif game_number == 64
          game.schedule_game(whos_playing(game_number),"East","South")
        elsif game_number == 65
          game.schedule_game(whos_playing(game_number),"Midwest","West")
        elsif game_number == 66
          game.schedule_game(whos_playing(game_number),self.games.find_by_number(64).winner.team.division,self.games.find_by_number(65).winner.team.division)
        end
      end

      if(game.scheduled?)
        game.play_game
      end
     
    end  ## END GAME NUMBER LOOP
  end

  def whos_playing(game_number)
## MIGHT NEED A BETTER WAY TO DO THIS WHEN WE HAVE 68 GAMES....
## COULD LOOP THORUGH EACH DIVISION...then use the same layout, then at the bottom play out the final four
    whos_playing = case game_number
    #EAST
      when 0 then [16,17]
      when 1 then [1,self.games[0].winner.team.seed] ### NEED TO PLAY THIS FIRST
      when 2 then [2,15]
      when 3 then [3,14]
      when 4 then [4,13]
      when 5 then [5,12]
      when 6 then [6,11]
      when 7 then [7,10]
      when 8 then [8,9]
      when 9 then [self.games[1].winner.team.seed,self.games[8].winner.team.seed]
      when 10 then [self.games[2].winner.team.seed,self.games[7].winner.team.seed]
      when 11 then [self.games[3].winner.team.seed,self.games[6].winner.team.seed]
      when 12 then [self.games[4].winner.team.seed,self.games[5].winner.team.seed]
      when 13 then [self.games[9].winner.team.seed,self.games[12].winner.team.seed]
      when 14 then [self.games[11].winner.team.seed,self.games[10].winner.team.seed]
      when 15 then [self.games[13].winner.team.seed,self.games[14].winner.team.seed]
    #MIDWEST
      when 16 then [16,17]
      when 17 then [1,self.games[16].winner.team.seed]
      when 18 then [2,15]
      when 19 then [3,14]
      when 20 then [4,13]
      when 21 then [5,12]
      when 22 then [6,11]
      when 23 then [7,10]
      when 24 then [8,9]
      when 25 then [self.games[17].winner.team.seed,self.games[24].winner.team.seed]
      when 26 then [self.games[18].winner.team.seed,self.games[23].winner.team.seed]
      when 27 then [self.games[19].winner.team.seed,self.games[22].winner.team.seed]
      when 28 then [self.games[20].winner.team.seed,self.games[21].winner.team.seed]
      when 29 then [self.games[25].winner.team.seed,self.games[28].winner.team.seed]
      when 30 then [self.games[27].winner.team.seed,self.games[26].winner.team.seed]
      when 31 then [self.games[29].winner.team.seed,self.games[30].winner.team.seed]
    #SOUTH
      when 32 then [16,17]
      when 33 then [1,self.games[32].winner.team.seed]
      when 34 then [2,15]
      when 35 then [3,14]
      when 36 then [4,13]
      when 37 then [5,12]
      when 38 then [6,11]
      when 39 then [7,10]
      when 40 then [8,9]
      when 41 then [self.games[33].winner.team.seed,self.games[40].winner.team.seed]
      when 42 then [self.games[34].winner.team.seed,self.games[39].winner.team.seed]
      when 43 then [self.games[35].winner.team.seed,self.games[38].winner.team.seed]
      when 44 then [self.games[36].winner.team.seed,self.games[37].winner.team.seed]
      when 45 then [self.games[41].winner.team.seed,self.games[44].winner.team.seed]
      when 46 then [self.games[43].winner.team.seed,self.games[42].winner.team.seed]
      when 47 then [self.games[45].winner.team.seed,self.games[44].winner.team.seed]
    #WEST
      when 48 then [16,17]
      when 49 then [1,self.games[48].winner.team.seed]
      when 50 then [2,15]
      when 51 then [3,14]
      when 52 then [4,13]
      when 53 then [5,12]
      when 54 then [6,11]
      when 55 then [7,10]
      when 56 then [8,9]
      when 57 then [self.games[49].winner.team.seed,self.games[56].winner.team.seed]
      when 58 then [self.games[50].winner.team.seed,self.games[55].winner.team.seed]
      when 59 then [self.games[51].winner.team.seed,self.games[54].winner.team.seed]
      when 60 then [self.games[52].winner.team.seed,self.games[53].winner.team.seed]
      when 61 then [self.games[57].winner.team.seed,self.games[60].winner.team.seed]
      when 62 then [self.games[59].winner.team.seed,self.games[58].winner.team.seed]
      when 63 then [self.games[61].winner.team.seed,self.games[62].winner.team.seed]

      when 64 then [self.games[15].winner.team.seed,self.games[47].winner.team.seed]
      when 65 then [self.games[31].winner.team.seed,self.games[63].winner.team.seed]
      when 66 then [self.games[64].winner.team.seed,self.games[65].winner.team.seed]

    end
  end

  def play_games    
    self.games.each do |game_number|
      self.games.find_by_number(game_number).play_game
    end
  end

end
