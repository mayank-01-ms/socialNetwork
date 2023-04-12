module UsersHelper
    def are_friends(user1, user2)
        check = Friendship.find_by({user_id: user1, friend_id: user2})
        !check.nil?
    end
end
