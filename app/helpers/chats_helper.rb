module ChatsHelper
    def get_username_from_id(id)
        user = User.find(id)
        user.username
    end
end
