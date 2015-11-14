class Window_MenuStatus < Window_Selectable
  def initialize
    super(80, 80, 480, 120)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.name = $fontface
    self.contents.font.size = $fontsize
    create_arrows
    refresh
    self.active = false
    self.index = -1
  end

  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size
    for i in 0...$game_party.actors.size
      x = 64
      y = i * 116
      actor = $game_party.actors[i]
      draw_actor_graphic(actor, x - 40, y + 80)
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 144, y)
      draw_actor_level(actor, x, y + 32)
      draw_actor_state(actor, x + 90, y + 32)
      draw_actor_exp(actor, x, y + 64)
      draw_actor_hp(actor, x + 236, y + 32)
      draw_actor_sp(actor, x + 236, y + 64)
    end
  end

  def create_arrows
    create_arrow_left
    create_arrow_right
  end

  def create_arrow_left
    @arrow_left = Sprite.new
    @arrow_left.bitmap = Bitmap.new("Graphics/Pictures/arrow_left")
    @arrow_left.x = self.x / 2 + 10
    @arrow_left.y = (@arrow_left.bitmap.height + self.height / 2)
    @arrow_left.z = 200
  end
  
  def create_arrow_right
    @arrow_left = Sprite.new
    @arrow_left.bitmap = Bitmap.new("Graphics/Pictures/arrow_right")
    @arrow_left.x = self.width + @arrow_left.bitmap.width + 10
    @arrow_left.y = (@arrow_left.bitmap.height + self.height / 2)
    @arrow_left.z = 200
  end
end