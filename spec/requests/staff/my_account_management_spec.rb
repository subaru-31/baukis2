require "rails_helper"

describe "管理者による職員管理", "ログイン前" do
  include_examples "a protected staff controller", "staff/accounts"
end

describe "職員による自分のアカウントの管理" do

  before do
    post staff_session_url, params: { 
      staff_login_form: { 
        email: staff_member.email,
        password: "pw" 
      }
    }
  end

  describe "情報表示" do
    let(:staff_member) { create(:staff_member) }

    it "成功" do
      get staff_account_url
      expect(response.status).to eq(200)
    end

    it "停止フラグがセットされたら強制ログアウト" do
      staff_member.update_column(:suspended, true)
      get staff_account_url
      expect(response).to redirect_to(staff_root_url)
    end

    it "セッションタイムアウト" do
      # 定数TIMEOUTで指定した60分後に現在時刻を設定し、advanceメソッドで１秒進める（現在時刻 + 60分 + 1秒）
      travel_to Staff::Base::TIMEOUT.from_now.advance(seconds: 1)
      get staff_account_url
      expect(response).to redirect_to(staff_login_url)
    end
  end

  describe "更新" do
    let(:params_hash) { attributes_for(:staff_member) }
    let(:staff_member) { create(:staff_member) }

    it "email属性を変更する" do
      params_hash.merge!(email: "test@email.com")
      patch confirm_staff_account_url, params: { staff_member: params_hash }
      patch staff_account_url, params: { staff_member: params_hash, commit: true }
      staff_member.reload
      expect(staff_member.email).to eq("test@email.com")
    end

    it "例外ActionController::ParameterMissingが発生" do
      expect { patch staff_account_url }.to raise_error(ActionController::ParameterMissing)
    end
  
    it "end_dateの値は更新不可" do
      params_hash.merge!(end_date: Date.tomorrow)
      expect {
        patch staff_account_url, params: { staff_member: params_hash }
        staff_member.end_date 
      }.not_to change { staff_member.end_date }
    end
  end
end