require "rails_helper"

describe "管理者のアカウント制御" do
  before do
    post admin_session_url, params: { admin_login_form: { email: administrator.email, password: "pw" } }
  end

  describe "強制ログアウトのテスト" do
    let(:administrator) { create(:administrator) }

    it "停止フラグがセットされたら強制ログアウト" do
      administrator.update_column(:suspended, true)
      get admin_root_url
      expect(response).to redirect_to(admin_login_url)
    end

    it "セッションタイムアウト" do
      travel_to Admin::Base::TIMEOUT.from_now.advance(seconds: 1)
      get admin_root_url
      expect(response).to redirect_to(admin_login_url)
    end
  end
end
