class Customer::AccountsController < Customer::Base
  def show
    @customer = current_customer
  end

  def edit
    @customer_form = Customer::AccountForm.new(current_customer)
  end

  def confirm
    @customer_form = Customer::AccountForm.new(current_customer)
    @customer_form.assign_attributes(params[:form])
    if @customer_form.valid?
      render :confirm
    else
      flash.now.alert = "入力に誤りがあります。"
      render :edit
    end
  end

  def update
    @customer_form = Customer::AccountForm.new(current_customer)
    @customer_form.assign_attributes(params[:form])
    # commitはsubmitのnameオプションのデフォルト値
    if params[:commit]
      if @customer_form.save
        flash.notice = "アカウント情報を更新しました。"
        redirect_to :customer_account
      else
        flash.now.alert = "入力に誤りがあります。"
        render :edit
      end
    else
      render :edit
    end
  end
end
