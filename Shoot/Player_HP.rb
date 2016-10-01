=begin
  Autor: Resque
  Script: This is part of Resque Shoot System
  Email: rogessonb@gmail.com
  Date: 24/09/2016
=end

class Player_HP
  attr_accessor :current_hp

  def initialize(player, max_hp)
    @player     = player
    @max_hp     = max_hp
    @current_hp = @max_hp
    @old_hp     = 0

    @current_position = [player.screen_x - 60, player.screen_y]
    @old_possition    = []

    create_hp_bar
  end

  def update
    draw_hp_bar
    @current_position = [@player.screen_x - 60, @player.screen_y]

    if @current_position != @old_possition
      @spr_bar.x = @player.screen_x - 60
      @spr_bar.y = @player.screen_y
      @old_possition = @current_position
    end
  end

  def terminate
    @spr_bar.dispose
  end

  private

  def create_hp_bar
    @spr_bar        = Sprite.new
    @spr_bar.bitmap = Bitmap.new(120, 20)
  end

  def draw_hp_bar
    if @current_hp != @old_hp
      @spr_bar.bitmap = Bitmap.new(120, 20)
      @spr_bar.bitmap.draw_text(0, 0, 120, 20, "(#{@current_hp}/#{@max_hp})", 1)
      @old_hp = @current_hp
    end
  end
end