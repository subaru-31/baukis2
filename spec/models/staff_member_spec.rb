require 'rails_helper'

RSpec.describe StaffMember, type: :model do
  describe "password=" do
    it "文字列を与えるとhash_passwordは長さ６０の文字列になる" do
      member = StaffMember.new
      member.password = 'hogehoge'
      expect(member.hashed_password).to be_kind_of(String)
      expect(member.hashed_password.size).to eq(60)
    end

    it "nilを与えると、hash_passwordはnilになる" do
      member = StaffMember.new(hashed_password: "hoge")
      member.password = nil
      expect(member.hashed_password).to be_nil
    end
  end

  describe "値の正規化" do
    it "email前後の空白を除去" do
      member = create(:staff_member, email: " test@example.com")
      expect(member.email).to eq("test@example.com")
    end

    it "emailに含まれる全角英数字記号を半角に変換" do
      member = create(:staff_member, email: "ｔｅｓｔ@email.com")
      expect(member.email).to eq("test@email.com")
    end

    it "email前後の全角スペースを除去" do
      member = create(:staff_member, email: "　test@email.com")
      expect(member.email).to eq("test@email.com")
    end

    it "family_name_kanaに含まれるひらがなをカタカナに変換" do
      member = create(:staff_member, family_name_kana: "てすと")
      expect(member.family_name_kana).to eq("テスト")
    end

    it "family_name_kanaに含まれる半角カナを全角カナに変換" do
      member = create(:staff_member, family_name_kana: "ﾃｽﾄ")
      expect(member.family_name_kana).to eq("テスト")
    end
  end

  describe "バリデーション" do
    it "family_nameは漢字、ひらがな、カタカナ、アルファベット以外を含まない" do
      member = build(:staff_member, family_name: " 　")
      expect(member).not_to be_valid
    end

    it "given_nameは漢字、ひらがな、カタカナ、アルファベット以外を含まない" do
      member = build(:staff_member, given_name: " 　")
      expect(member).not_to be_valid
    end

    it "@を２個含むemailは無効" do
      member = build(:staff_member, email: "test@@example.com")
      expect(member).not_to be_valid
    end

    it "漢字を含むfamily_name_kanaは無効" do
      member = build(:staff_member, family_name_kana: "田中テスト")
      expect(member).not_to be_valid
    end

    it "長音を含むfamily_name_kanaは無効" do
      member = build(:staff_member, family_name_kana: "エリー")
      expect(member).to be_valid
    end

    it "他の職員のメールアドレスと重複したemailは無効" do
      member1 = create(:staff_member)
      member2 = build(:staff_member, email: member1.email)

      expect(member2).not_to be_valid
    end
  end

end
