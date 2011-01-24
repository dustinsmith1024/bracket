class Odds < ActiveRecord::Base


  def self.game_odds(seed_one, seed_two)
    self.find(:first, :conditions => ["seed_one = ? and seed_two = ?",seed_one,seed_two]).chance
  end

end
