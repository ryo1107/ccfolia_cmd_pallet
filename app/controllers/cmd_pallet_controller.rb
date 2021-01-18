class CmdPalletController < ApplicationController
  def index
  end

  def new
    @ccfolia_url = CmdPallet.new
  end

  def show
    # https://chara.revinx.net/coc_view/159990
    status, skill = get_character_info(params[:ccfolia_url])
    status_hash = make_status_hash(status)
    skill_hash = make_skill_hash(skill)

    @cmd_pallet = make_pallet(status_hash, make_skill_pallet(skill_hash))
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
        skill_hash["#{skill_tr.at('th').content}"] = skill_tr.search('td').last.content if skill_tr.search('td').last.content.to_i >= 0
      end
    end
    skill_hash
  end

  def make_skill_pallet(skill_hash)
    skill_array = []
    skill_hash.each do |name, num|
      skill_array.push("CCB<=#{num} 【#{name}】")
    end
    skill_pallet = skill_array.join("\n")
  end

  def make_pallet(status_hash, skill_pallet)
    cmd_pallet = <<EOS
    【能力値×ｎ】---
    CCB<=({STR}*5) 【STR】
    CCB<=({CON}*5) 【CON】
    CCB<=({POW}*5) 【POW】
    CCB<=({DEX}*5) 【DEX】
    CCB<=({APP}*5) 【APP】
    CCB<=({SIZ}*5) 【SIZ】
    CCB<=({INT}*5) 【INT】
    CCB<=({EDU}*5) 【EDU】
    
    CCB<={SAN値} 【SANチェック】
    CCB<= #{status_hash['アイデア']}【アイデア】
    CCB<= #{status_hash['幸運']}【幸運】
    CCB<= #{status_hash['知識']}【知識】
    
    【技能値】-------
    #{skill_pallet}
    
    ////////////
    //STR = #{status_hash['STR']}
    //CON = #{status_hash['CON']}
    //POW = #{status_hash['POW']}
    //DEX = #{status_hash['DEX']}
    //APP = #{status_hash['APP']}
    //SIZ = #{status_hash['SIZ']}
    //INT = #{status_hash['INT']}
    //EDU = #{status_hash['EDU']}
    //db = #{status_hash['db']}
EOS
  end
end

# CmdPalletController.new.get_character_info

# 【能力値×ｎ】---
# CCB<=({STR}*5) 【STR】
# CCB<=({CON}*5) 【CON】
# CCB<=({POW}*5) 【POW】
# CCB<=({DEX}*5) 【DEX】
# CCB<=({APP}*5) 【APP】
# CCB<=({SIZ}*5) 【SIZ】
# CCB<=({INT}*5) 【INT】
# CCB<=({EDU}*5) 【EDU】

# CCB<={SAN値} 【SANチェック】
# CCB<= 【アイデア】
# CCB<= 【幸運】
# CCB<= 【知識】

# 【技能値】-------
# CCB<=55【キック】
# CCB<=52【回避】
# CCB<=50【応急手当】
# CCB<=50【隠れる】
# CCB<=50【写真術】
# CCB<=60【運転(自動車)】
# CCB<=50【忍び歩き】
# CCB<=70【水泳】
# CCB<=65【目星】
# CCB<=45【聞き耳】
# CCB<=50【信用】
# CCB<=45【説得】
# CCB<=71【生物学】

# ////////////
# //STR = 
# //CON = 
# //POW = 
# //DEX = 
# //APP = 
# //SIZ = 
# //INT = 
# //EDU = 
# //db = +
