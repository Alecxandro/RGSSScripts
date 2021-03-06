=begin 
  * Script RGSS para RPG Maker VX ACE
  
  * Nome: Item Menu
  * Descrição: Muda Layout e informações do menu de item.
  * Autor: Resque
  * Data: 10/12/2014
=end

#==============================================================================
# ** Scene_Item_new  [TODO] Mudar este nome.
#==============================================================================

#--------------------------------------------------------------------------
# * Classe responsável por exibir as informações do item selecionado.
#--------------------------------------------------------------------------
class Item_Info_Window < Window_Base
  attr_accessor :item

  def initialize(x, y, width, height)
    super(x, y, width, height)
    @item = nil
  end
  
  #--------------------------------------------------------------------------
  # * set_text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    if SceneManager.scene_is?(Scene_Item_New) and @item
      draw_item_informations
    else
      draw_text_ex(4, 0, @text)
    end
  end

  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end

  #--------------------------------------------------------------------------
  # * Return type item type.
  #--------------------------------------------------------------------------
  def item_type
    if @item.is_a? RPG::Weapon
      $data_system.weapon_types[@item.wtype_id]
    else 
      $data_system.armor_types[@item.atype_id]
    end
  end

  #--------------------------------------------------------------------------
  # * Return element name.
  #--------------------------------------------------------------------------
  def item_element
      element_index = @item.features.first.data_id.to_i
      $data_system.elements[element_index]
  end

  #--------------------------------------------------------------------------
  # * set_item
  #--------------------------------------------------------------------------
  def set_item(item)
    self.item = item
    #--------------------------------------------------------------------------
    # * Atualiza janela de informações do item.
    #------------------------------------------------------------------------
    if SceneManager.scene_is?(Scene_Item_New)
        description = short_description
      else
        description = item.description
    end

    #--------------------------------------------------------------------------
    # * Exibe descrição do item selecionado.
    #--------------------------------------------------------------------------
    set_text(item ?  description : "")
  end

  #--------------------------------------------------------------------------
  # * Exibe a descrição do item em várias linhas
  #--------------------------------------------------------------------------
  def short_description
    if @item
      word_wrap(@item.description, 30)
    else
      ""
    end
  end

  #---------------------------------------------------------------------------
  # * Metodo que formata o texto da descrição do item quebrando as linhas.
  #---------------------------------------------------------------------------
  def word_wrap(text, line_width)
    words = text.split(" ")
    line = ''
    lines = []
    new_line = true

    for word in words
      if line.size + word.size < line_width
        line << "#{word} "
      else
        new_line = true
        line = "\n#{word} "
      end

      lines << line if new_line
      new_line = false
    end

    lines.join
  end

  #---------------------------------------------------------------------------
  # * Exibe icone do item.
  #---------------------------------------------------------------------------
  def draw_item_icon
    draw_icon(@item.icon_index, 25, 23)
  end

  #---------------------------------------------------------------------------
  # * Exibe informações do item.
  #---------------------------------------------------------------------------
  def draw_item_info
    draw_text_ex(75, 4,  "Nome: #{@item.name}")
    draw_text_ex(75, 24, "Tipo: #{item_type}")
    draw_text_ex(75, 48, "Atributo: #{item_element}")
  end

  #---------------------------------------------------------------------------
  # * Exibe descrição do item.
  #---------------------------------------------------------------------------
  def draw_description
    draw_text_ex(8, 160, @text)
  end

  #---------------------------------------------------------------------------
  # * Exibe atributos do item na esquerda da janela.
  #---------------------------------------------------------------------------
  def draw_left_attributes
    draw_text_ex(25, 80,  %Q{ATK    > #{@item.params[2]}})
    draw_text_ex(25, 100, %Q{AGI    > #{@item.params[6]}})
    draw_text_ex(25, 120, %Q{MAX HP > #{@item.params[0]}})
  end

  #---------------------------------------------------------------------------
  # * Exibe atributos do item na direita da janela.
  #---------------------------------------------------------------------------
  def draw_right_attributes
    draw_text_ex(180, 80,  %Q{DEF    > #{@item.params[3]}})
    draw_text_ex(180, 100, %Q{SOR    > #{@item.params[7]}})
    draw_text_ex(180, 120, %Q{MAX MP > #{@item.params[1]}})
  end

  #---------------------------------------------------------------------------
  # * Exibe todas as informações do item.
  #---------------------------------------------------------------------------
  def draw_item_informations
    draw_item_icon
    draw_item_info
    draw_description
    draw_left_attributes
    draw_right_attributes
  end
end

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Chamando a scene do novo menu.
  #--------------------------------------------------------------------------
  def command_item
    SceneManager.call(Scene_Item_New)
  end
end

class Window_ItemList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Mudando a lista de itens para vertical.
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end

  #--------------------------------------------------------------------------
  # * Override do draw_item_number
  #--------------------------------------------------------------------------
  def draw_item_number(rect, item)
    amount_symbol = SceneManager.scene_is?(Scene_Item_New) ? "%2dx" : ":%2d"
    draw_text(rect, sprintf(amount_symbol, $game_party.item_number(item)), 2)
  end

  #--------------------------------------------------------------------------
  # * Removendo quantidade de item.
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
      draw_item_number(rect, item)
    end
  end
end

# Override da Scene_Item_New
class Scene_Item_New < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_category_window
    create_item_window
    create_item_info_window
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.y = 0
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy

    @item_window_height = wh
    @item_window = Window_ItemList.new(0, wy, (Graphics.width / 2.5), wh)
    @item_window.viewport = @viewport
    
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))

    @category_window.item_window = @item_window
  end

  #--------------------------------------------------------------------------
  # * Cria a janela de informações do item selecionado.
  #--------------------------------------------------------------------------
  def create_item_info_window
    x       = @category_window.width / 2.5
    y       = @category_window.height
    width   = @category_window.width / 1.66
    height  = @item_window_height.to_i

    @item_info_window = Item_Info_Window.new(x, y, width, height)

    @category_window.help_window  = @item_info_window
    @item_window.help_window      = @item_info_window
  end

  #--------------------------------------------------------------------------
  # * Category [OK]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
    @item_info_window.set_item(item) if item
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    $game_party.last_item.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
    @item_info_window.contents.clear if @item_info_window
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_item
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @item_window.redraw_current_item
  end
end

#--------------------------------------------------------------------------
# * Override Window_Base
#--------------------------------------------------------------------------
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Override do draw_item_name
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    if SceneManager.scene_is?(Scene_Item_New)
      change_color(normal_color, enabled)
      draw_text(x, y, width, line_height, item.name)
    else
      draw_icon(item.icon_index, x, y, enabled)
      change_color(normal_color, enabled)
      draw_text(x + 24, y, width, line_height, item.name)
    end
  end
end