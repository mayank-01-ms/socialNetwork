class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
        @user = current_user
    end

    def settings
        @user = current_user
    end

    def update_settings
        @user = current_user

        if @user.update(setting_params)
            flash[:notice] = "Settings updated successfully"
            redirect_to settings_path
        else
            render 'settings', status: :unprocessable_entity
        end
    end

    private 
        
        def setting_params
            params.require(:user).permit(
                :posts_visible_to,
                :search_visibility,
                :allow_invites_from
            )
        end
end
