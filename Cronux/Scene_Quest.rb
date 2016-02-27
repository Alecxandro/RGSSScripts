class Scene_Quest < Scene_Base

  attr_reader :window_quest_info, :window_quest_list

  include QUEST_INFO

  def main
    create_windows
    setup

    Graphics.transition

    loop do
      Graphics.update
      Input.update
      update

      if $scene != self
        break
      end
    end

    Graphics.freeze

    dispose_windows
  end

  def update
    update_windows
    listen_event
  end

  private

  def setup
    @window_quest_list.execute
  end

  def create_windows
    @window_quest      = Window_Quest.new
    @window_quest_list = Window_Quest_List.new(quests)
    @window_quest_info = Window_Quest_Info.new
  end

  def update_windows
    @window_quest.update
    @window_quest_list.update
    @window_quest_info.update
  end

  def dispose_windows
    @window_quest.dispose
    @window_quest_list.dispose
    @window_quest_info.dispose
  end

  def quests
    @quest_list ||= create_quests
  end

  def create_quests
    @quest_list = QUEST_INFO::list.collect do |quest|
                Quest.new(
                          quest["name"],
                          quest["description"],
                          quest["new_quest"],
                          quest["type"],
                          quest["completed"],
                          quest["rewards"]
                        )
              end
  end
end