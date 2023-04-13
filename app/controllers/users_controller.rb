class UsersController < ApplicationController
    before_action :authenticate_user!

    def add_friend
        @friend_id = params['friend']
        @friend_to_add = User.find(@friend_id)
        if @friend_to_add.nil?
            flash[:alert] = "User doesn't exists"
            redirect_to root_path
        else
            if helpers.already_sent_invite?(current_user, @friend_id) || helpers.are_friends?(current_user, @friend_id)
                flash[:alert] = "Already sent an invite or is friend with the user"
                redirect_to profile_path(@friend_id)
            else
                invite = Invitation.create({sent_to: @friend_id, user_id: current_user.id})

                if invite.save
                    flash[:notice] = "Invite sent successfully"
                else
                    flash[:alert] = "Could not sent invite"
                end
                redirect_to profile_path(@friend_id)
            end
        end

        # @friend_id = params['friend']
        # @friend_to_add = User.find(@friend_id)
        # if @friend_to_add.nil?
        #     flash[:alert] = "User doesn't exists"
        #     redirect_to root_path
        # else
        #     if helpers.are_friends?(current_user, @friend_id)
        #         flash[:alert] = "Already friends with this user"
        #         p "Also check for user settings"
        #         redirect_to profile_path(@friend_id)
        #     else 
        #         friendship = Friendship.create({user_id: current_user.id, friend_id: @friend_id})
                
        #         if friendship.save
        #             flash[:notice] = "Invite sent successfully"
        #         else
        #             flash[:alert] = "Could not sent invite"
        #         end
        #         redirect_to profile_path(@friend_id)
        #     end
        # end
    end

    def friends
        @friends = current_user.friends
    end

    def index
        @users = User.all
    end

    def invites
        @invites = Invitation.all.where({sent_to: current_user})
    end

    def posts
        @posts = Post.all.where({user_id: params[:user_id]})
    end

    def show
        @user = User.find(params[:id])
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
