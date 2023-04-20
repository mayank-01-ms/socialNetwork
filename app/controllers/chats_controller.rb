class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = Chat.where(from: current_user.id).or(Chat.where(user_id: current_user.id))
  end

  def create 
    @friend_id = params[:friend_id]

    unless helpers.are_friends?(current_user, @friend_id)
      flash[:alert] = "Cannot message the non-friend user"
      redirect_to root_path and return
    end

    # add uniqueness to model and dont do this manually
    @check = Chat.find_by({from: current_user.id, user_id: @friend_id})
    unless @check.nil?
      flash[:alert] = "Chat already exits with the user"
      redirect_to chats_path and return
    end

    @chat = Chat.create(from: current_user.id, user_id: @friend_id)
    flash[:notice] = "Chat created successfully"
    redirect_to chats_path
  end

  def create_message
    @friend_username = params[:username]
    @friend = User.find_by({username: @friend_username})
    @message = params[:message]
    @chat = Chat.find_by({from: current_user.id, user_id: @friend.id})

    if @chat.nil?
      @chat = Chat.find_by({from: @friend.id, user_id: current_user.id})
    end

    if @chat.nil?
      flash[:alert] = "Invalid chat"
      redirect_to chats_path and return
    end

    Message.create({user_id: current_user.id, chat_id: @chat.id, content: @message})
    flash[:notice] = "Message sent successfully"
    redirect_to chat_path(@friend_username)
  end

  def show
    @friend_username = params[:username]
    @friend = User.find_by({username: @friend_username})

    if @friend.nil?
      flash[:alert] = "Cannot find user"
      redirect_to chats_path and return
    end

    @chat = Chat.find_by({from: current_user.id, user_id: @friend.id})
    if @chat.nil?
      @chat = Chat.find_by({from: @friend.id, user_id: current_user.id})
    end
    
    if @chat.nil?
      flash[:alert] = "No such chat exists"
      redirect_to chats_path
    end

    @messages = Message.where(chat_id: @chat)
  end

end
