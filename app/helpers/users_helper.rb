module UsersHelper
    def are_friends?(user1, user2)
        check = Friendship.find_by({user_id: user1, friend_id: user2})
        !check.nil?
    end

    def already_sent_invite?(from, to)
        check = Invitation.find_by({user_id: from, sent_to: to})
        !check.nil?
    end
end
