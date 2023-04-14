class UsersController < ApplicationController
    before_action :authenticate_user!

    def add_friend
        @friend_id = params['friend']
        @friend_to_add = User.find(@friend_id)

        if @friend_id == current_user.id.to_s
            flash[:notice] = "Cannot send invite to yourself"
            redirect_to root_path and return
        end

        if @friend_to_add.nil?
            flash[:alert] = "User doesn't exists"
            redirect_to root_path
        elsif helpers.can_send_invites?(current_user, @friend_id) == false
            flash[:notice] = "Cannot send invite to this user due to their privacy settings"
        else
            if helpers.already_sent_invite?(current_user, @friend_id) || helpers.are_friends?(current_user, @friend_id)
                flash[:alert] = "Already sent an invite or is friend with the user"
            else
                invite = Invitation.create({sent_to: @friend_id, user_id: current_user.id})

                if invite.save
                    flash[:notice] = "Invite sent successfully"
                else
                    flash[:alert] = "Could not sent invite"
                end
            end
        end
        redirect_to profile_path(@friend_id)

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

    def feed
        @friends = current_user.friends
        @posts = Post.where({user_id: @friends}).where("created_at > ?", 24.hours.ago)
        
        @suggestions = User.where.not({id: @friends}).where.not({id: current_user}).limit(10)
    end

    def index
        @users = User.all
    end

    def invites
        @invites = Invitation.all.where({sent_to: current_user})
    end

    def posts
        user_id = params[:user_id]
        if helpers.can_see_posts?(current_user, user_id)
            if user_id == current_user.id.to_s or helpers.are_friends?(current_user, user_id)
                @posts = Post.all.where({user_id: user_id})
            else 
                @posts = Post.all.where({user_id: user_id}).where({is_private: false})
            end
        else
            flash[:notice] = "You cannot this user posts due to their privacy settings"
            @posts = []
        end
    end

    def search
        if params[:query].blank?
            render 'search' and return
        else
            @query = params[:query]
            @results = User.where("first_name || ' ' || last_name LIKE ?", "%#{@query}%").limit(30)
        end
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
