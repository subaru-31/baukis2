require "rails_helper"

feature "職員のアカウント変更" do
  include FeaturesSpecHelper
  let(:staff_member) { create(:staff_member) }

  before do
    switch_namespace(:staff)
    login_as_staff_member(staff_member)
    click_link "アカウント"
    click_link "アカウント情報編集"
  end

  scenario "職員が名前、メールアドレスを更新する" do
    fill_in "メールアドレス", with: "hogehoge@email.com"
    fill_in "staff_member_family_name", with: "試験"
    fill_in "staff_member_given_name", with: "太郎"
    fill_in "staff_member_family_name_kana", with: "シケン"
    fill_in "staff_member_given_name_kana", with: "タロウ"

    click_button "確認画面に進む"
    click_button "更新"

    staff_member.reload
    expect(staff_member.email).to eq("hogehoge@email.com")
    expect(staff_member.family_name).to eq("試験")
  end

  scenario "顧客が名前に無効な値を入力する" do
    fill_in "staff_member_family_name", with: "hoge"
    
    click_button "確認画面に進む"

    expect(page).to have_css("header span.alert")
    expect(page).to have_css("div.field_with_errors input#staff_member_family_name")
  end
end