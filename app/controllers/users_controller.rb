class UsersController < ApplicationController
  def update

  if @user.update(user_params)
    redirect_to edit_user_path(@user), notice: "Signature uploaded."
  else
    render :edit
  end
end

private

  def user_params
    params.require(:user).permit(:signature)
  end
end
