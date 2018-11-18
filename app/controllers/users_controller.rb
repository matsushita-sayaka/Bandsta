class UsersController < ApplicationController
  # before_action :authenticate_user!, :only => [:show, :index, :edit, :update]
  before_action :authenticate_user!, :only => [:show, :index]
    
  def show
    
    @user = User.find(params[:id])
      @friend_status = ""
        # Friend.where(follower: current_user.id).each do |f|
          if Friend.find_by('follower = ? and followed = ?', current_user.id, params[:id]) 
            if Friend.find_by('follower = ? and followed = ?', params[:id], current_user.id) 
              @friend_status = "f"
            else
              @friend_status = "r"
            end    
          else
            if Friend.find_by('follower = ? and followed = ?', params[:id], current_user.id) 
              @friend_status = "w"
            else
              @friend_status = ""
            end
          end  
        #   if Friend.find_by('follower = ? and followed = ?', f.followed, current_user.id) 
        #   logger.debug("--------------------- 友達　f.followed = #{f.followed}")
        #     @friend_status = "f"
        #   else
        #   logger.debug("--------------------- 申請中f.followed = #{f.followed}")
        #     @friend_status = "r"
        #   end
        # end
        
        # Friend.where(followed: current_user.id).each do |f|
        #   if !Friend.find_by('follower = ? and followed = ?', current_user.id, f.follower) 
        #   logger.debug("--------------------- 承認待ち　f.followed = #{f.follower}")
        #     @friend_status = "w"
        #   end
        # end    
    @band_details = BandDetail.where(user_id: params[:id]).order(id: "desc")
    @bdcomment = BandDetail.where(user_id: params[:id]).last
    
    @belong_bands = BelongBand.where(user_id: params[:id])
    @bandmembers = BelongBand.where(band_id: params[:id])
    # Nov 18
    @posts = Post.where(writer_id: params[:id])
    @nfriends = [] #空にして
      Friend.where(follower: params[:id]).each do |f| #paramsがfollowerしてるだけ引っ張って
      if Friend.find_by('follower = ? and followed = ?', f.followed, params[:id])  #followし返してくれてるかifして
        @nfriends.push(f.followed)  #成立してる数だけ配列にどん
      end
    end
            
  end
  
  def index
    @users = User.search(params[:search])
    # @users = User.all
  end
  
  # def likes
  #   logger.debug("--------------------- Likes_user_id = #{params[:id]}")
    
  #   @user = User.find_by(id: params[:id])
  #   @likes = Like.where(user_id: @user.id)
  # end
  
  # def edit
  #   @user = User.find(params[:id])
  #   if @user.id == current_user.id
  #   else
  #     redirect_to "/"
  #     flash[:alert] = "You don't have permission to access"
  #   end
  # end
  
  # def update
  #   @user = User.find(params[:id])
  #   if @user.id == current_user.id
  #     @user.update(params.require(:user).permit(:name, :user_type, :banmas_id, :profile, :genre, :email, :password, :icon, :area, :gender, :waiting, :part))
  #     redirect_to "/users/#{@user.id}/edit"
  #     flash[:notice] = "Saved!"
  #   else
  #     redirect_to "/"
  #     flash[:alert] = "You have no permission to access"
  #   end
  # end
    
end #class -- end
