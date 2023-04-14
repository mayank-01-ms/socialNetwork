module UsersHelper
    def are_friends?(user1, user2)
        check = Friendship.find_by({user_id: user1, friend_id: user2})
        !check.nil?
    end

    def already_sent_invite?(from, to)
        check = Invitation.find_by({user_id: from, sent_to: to})
        !check.nil?
    end

    def is_friend_of_friends?(guest_user, current_user)
        user = User.find(current_user)
        friends = user.friends
        friends.each do | friend |
            return true if are_friends?(friend, guest_user)
        end
        return false
    end

    def can_see_posts?(viewer, viewee)
        return true if viewee == viewer
        user = User.find(viewee)
        if user.posts_visible_to == "friends"
            return are_friends?(viewer, viewee)
        elsif user.posts_visible_to == "friends_of_friends"
            return is_friend_of_friends?(viewer, viewee)
        end
        return true
    end

    def can_send_invites?(from, to)
        user = User.find(to)
        if user.allow_invites_from == "friends_of_friends"
            return is_friend_of_friends?(from, to)
        end
        return true
    end

    def is_profile_searchable?(viewer, viewee)
        return true if viewee == viewer
        user = User.find(viewee)
        if user.search_visibility == "friends"
            return are_friends?(viewer, viewee)
        elsif user.search_visibility == "friends_of_friends"
            return is_friend_of_friends?(viewer, viewee)
        end
        return true
    end

end
