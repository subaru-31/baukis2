require "rails_helper"

describe Staff::Authenticator do
  describe "#authenticate" do
    it "正しいパスワードならtrueを返す" do
      m = build(:staff_member)
      expect(Staff::Authenticator.new(m).authenticate("pw")).to be_truthy
    end

    it "誤ったパスワードならfalseを返す" do
      m = build(:staff_member)
      expect(Staff::Authenticator.new(m).authenticate("hoge")).to be_falsey
    end

    it "パスワードが未設定ならfalse" do
      m = build(:staff_member, password: nil)
      expect(Staff::Authenticator.new(m).authenticate("pw")).to be_falsey
    end

    it "停止フラグが立っていてもtrue" do
      m = build(:staff_member, suspended: true)
      expect(Staff::Authenticator.new(m).authenticate("pw")).to be_truthy
    end

    it "開始前ならfalse" do
      m = build(:staff_member, start_date: Date.tomorrow)
      expect(Staff::Authenticator.new(m).authenticate("pw")).to be_falsey
    end

    it "終了後ならfalse" do
      m = build(:staff_member, end_date: Date.yesterday)
      expect(Staff::Authenticator.new(m).authenticate("pw")).to be_falsey
    end
  end
end