class Window_MenuStatusCustom < Window_SelectableArrow
  
  attr_reader :option_name
  
  def initialize(option_name)

    create_arrows
    @option_name = option_name
    @actors = $game_party.actors
    
    super(250, 0, 428, 480, @arrow_left, @arrow_right, @actors)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.size = $fontsize
    @need_refresh = true

    
    create_character_box
    create_face_list

    refresh
    self.active = true
    self.index  = -1
  end

  def update
    super

    refresh
  end 

  def refresh
    #return unless @need_refresh
    self.contents.clear   
    draw_actor_status
    #@need_refresh = false
  end

  def close
    self.active = false
    dispose
  end

  def dispose
    super

    @arrow_left.dispose
    @arrow_right.dispose
    @face.dispose
    @face2.dispose
    @border_image.dispose
    @character_image.dispose
  end

  def draw_actor_status
    @item_max = @actors.size

    i = 3
    x = 0
    y = i * 116
    
    actor = @actors[arrow_index]

    draw_actor_name(actor, x, y)
    draw_actor_class(actor, x + 144, y)
    draw_actor_level(actor, x, y + 32)
    draw_actor_state(actor, x + 90, y + 32)
    draw_actor_exp(actor, x, y + 64)
    draw_actor_hp(actor, x + 236, y + 32)
    draw_actor_sp(actor, x + 236, y + 64)
  end

  def create_arrows
    create_arrow_left
    create_arrow_right
  end

  def create_arrow_left
    @arrow_left = Sprite.new
    @arrow_left.bitmap = Bitmap.new("Graphics/Pictures/arrow_left")

    @arrow_left.x = 270 
    @arrow_left.y = 125
    @arrow_left.z = 101

    @arrow_left.opacity = 190
  end
  
  def create_arrow_right
    @arrow_right = Sprite.new
    @arrow_right.bitmap = Bitmap.new("Graphics/Pictures/arrow_right")

    @arrow_right.x = 525
    @arrow_right.y = 125
    @arrow_right.z = 101

    @arrow_right.opacity = 190
  end

  def create_character_box
    x = 393
    1.times do
      character_box(x)
      x += 135
    end
  end

  def create_face_list
    @face = Sprite.new
    @face.bitmap = Bitmap.new("Graphics/Pictures/face_character1")

    @face.x = 525
    @face.y = 20
    @face.z = 101

    @face2 = Sprite.new
    @face2.bitmap = Bitmap.new("Graphics/Pictures/male_head")

    @face2.x = 564
    @face2.y = 20
    @face2.z = 101
  end

  def character_box(x)
    y = 17
    create_border(x, y)
    create_character_image(x, y)
  end

  def create_border(x, y)
    @border_image = Sprite.new
    @border_image.bitmap = Bitmap.new("Graphics/Pictures/overlay")
    @border_image.opacity = 200
    
    @border_image.x = x
    @border_image.y = y
    @border_image.z = 102
  end

  def create_character_image(x, y)
    @character_image = Sprite.new

    @character_image.bitmap = Bitmap.new("Graphics/Pictures/character_01")
    @character_image.x = x + 6
    @character_image.y = y + 6
    @character_image.z = 101
  end
end