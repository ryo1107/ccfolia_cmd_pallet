class CmdPalletController < ApplicationController
  def index
  end

  def new
    status, skill = get_character_info('https://chara.revinx.net/coc_view/159990')
    @status = make_status_hash(status)
    @skill = make_skill_hash(skill)
  end

  def create
  end

  def get_character_info(link)
    # link = 'https://chara.revinx.net/coc_view/159968'
    character_info = Mechanize.new
    page = character_info.get(link)
    status = page.at('div#status')
    skill = page.at('div#skill')
    [status, skill]
  end

  def make_status_hash(status)
    result_content = []
    status_content = status.elements.at_css('thead').search('th')
    status_content.each do |i|
      result_content << i.content
    end

    result_num = []
    status_num = status.elements.at_css('tbody').search('td')
    status_num.each do |i|
      result_num << i.content
    end
    result_content.zip(result_num).to_h
  end

  def make_skill_hash(skill)
    skill_hash = {}
    skills = skill.elements.search('tbody')
    skills.pop
    skills.each do |skill_tbody|
      next unless skill_tbody.content.present?

      skill_trs = skill_tbody.search('tr')
      skill_trs.each do |skill_tr|
        skill_hash["#{skill_tr.at('th').content}"] = skill_tr.search('td').last.content if skill_tr.search('td').last.content.to_i >= 20
      end
    end
    skill_hash
  end
end

# CmdPalletController.new.get_character_info