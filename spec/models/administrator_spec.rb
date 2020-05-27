require 'rails_helper'

RSpec.describe Administrator, type: :model do
  describe "password=" do
    it "パスワードに文字列が来た時に６０文字のハッシュ化されたパスワードがセットされる" do
      administrator = Administrator.new
      administrator.password = "foobar"
      expect(administrator.hashed_password).to be_kind_of(String)
      expect(administrator.hashed_password.size).to eq(60)
    end

    it "nilを与えるとhashed_passwordはnil" do
      administrator = Administrator.new
      administrator.password = nil
      expect(administrator.hashed_password).to be_nil
    end
  end
end
