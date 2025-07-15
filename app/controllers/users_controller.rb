class UsersController < ApplicationController
  before_action :set_user, only: [:destroy, :update_role, :edit, :update]

  def index
    @users = User.all
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: 'Пользователь успешно удалён.'
    else
      redirect_to users_path, alert: 'Ошибка при удалении пользователя.'
    end
  end

  def edit
    unless current_user&.admin?
      redirect_to users_path, alert: 'Тільки адміністратор може редагувати профіль.' and return
    end
  end

  def update
    unless current_user&.admin?
      redirect_to users_path, alert: 'Тільки адміністратор може редагувати профіль.' and return
    end
    if params[:user][:email].present? && User.where(email: params[:user][:email]).where.not(id: @user.id).exists?
      @user.errors.add(:email, 'Ця електронна пошта вже використовується')
      render :edit and return
    end
    update_params = params.require(:user).permit(:email, :password)
    update_params.delete(:password) if update_params[:password].blank?
    if @user.update(update_params)
      redirect_to users_path, notice: 'Профіль успішно оновлено.'
    else
      render :edit
    end
  end

  def update_role
    unless current_user&.admin?
      redirect_to users_path, alert: 'Тільки адміністратор може змінювати роль.' and return
    end
    if @user.update(role: params[:role])
      redirect_to users_path, notice: 'Роль успішно змінено.'
    else
      redirect_to users_path, alert: 'Помилка при зміні ролі.'
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
