class Admin::SessionsController < Admin::Base
  skip_before_action :authorize

  def new
    if current_administrator
      redirect_to :admin_root
    else
      @form = Admin::LoginForm.new
    end
  end

  def create
    @form =
      Admin::LoginForm.new(login_form_params)
    if @form.email.present?
      administrator = Administrator.find_by(email: @form.email.downcase)
    end
    
    if Admin::Authenticator.new(administrator).authenticate(@form.password)
      if administrator.suspended?
        flash.now.alert = "アカウントが凍結されています。"
        render :new
      else
        session[:administrator_id] = administrator.id
        session[:last_access_time] = Time.zone.now
        flash.notice = "ログインしました"
        redirect_to :admin_root
      end
    else
      flash.now.alert = "メールアドレスまたはパスワードが正しくありません。"
      render :new
    end
  end

  def destroy
    session.delete(:administrator_id)
    flash.notice = "ログインアウトしました"
    redirect_to :admin_root
  end

  private
    def login_form_params
      params.require(:admin_login_form).permit(:email, :password)
    end
end
