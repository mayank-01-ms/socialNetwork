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
    end
    
    def accept_invite
        @friend_id = params['friend']

        # if invite exists for current user, then only take action
        @check_invite = Invitation.find_by({sent_to: current_user.id, user_id: @friend_id})
        if @check_invite.nil?
            flash[:alert] = "Something went wrong"
            redirect_to root_path
        else
            friendship = Friendship.create({user_id: current_user.id, friend_id: @friend_id})
            
            if friendship.save
                @check_invite.destroy
                flash[:notice] = "Accepted invitation"
            else
                flash[:alert] = "Could not accept invite"
            end
            redirect_to invites_path
        end
    end

    def deny_invite
        @friend_id = params['friend']

        # if invite exists for logged in user, then only take action
        @check_invite = Invitation.find_by({sent_to: current_user.id, user_id: @friend_id})
        if @check_invite.nil?
            flash[:alert] = "Something went wrong"
            redirect_to root_path
        else
            @check_invite.destroy
            flash[:notice] = "Deleted invitation"
            redirect_to invites_path
        end
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
