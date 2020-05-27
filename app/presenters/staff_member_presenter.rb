class StaffMemberPresenter < ModelPresenter
  delegate :suspended?, :family_name, :given_name, :family_name_kana, :given_name_kana ,to: :object

  # 職員の停止フラグのon/offを表現する記号を返す。
  def suspended_mark
    suspended? ? raw("&#x2611;") : raw("&#x2610;")
  end

  def full_name
    "#{family_name} #{given_name}"
  end

  def full_name_kana
    "#{family_name_kana} #{given_name_kana}"
  end
end