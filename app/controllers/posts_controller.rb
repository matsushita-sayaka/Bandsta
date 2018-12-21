class PostsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :ensure_correct_user, {only: [:edit, :pdedit, :update, :pdupdate, :destroy]}
  
  def index
    @posts = Post.all.order(id: "desc")
  end
  
  def new
    @post = Post.new
  end
  
  def create
    require 'fileutils'
    # logger.debug("--------------------------file_name=#{params[:post][:file_name]}")
    
    @post = Post.new(post_params)
    
    if @post.save
        post_id = Post.last.id
      
          # 画像のアップロード対応
    
          if params[:images]
             save_flag = false
             cnt = 0
             params[:images].each { |image|
             
              @post_detail = PostDetail.new(post_detail_params)
              @post_detail.post_id = post_id
              
              # 松下さん
              if image.inspect.include?("jpg") || image.inspect.include?("JPG")
                @post_detail.file_type = "jpg"
              elsif image.inspect.include?("jpeg") || image.inspect.include?("JPEG")
                @post_detail.file_type = "jpeg"
              elsif image.inspect.include?("png") || image.inspect.include?("PNG")
                @post_detail.file_type = "png"
              elsif image.inspect.include?("mp4") || image.inspect.include?("MP4")
                @post_detail.file_type = "mp4"
              elsif image.inspect.include?("mov") || image.inspect.include?("MOV")
                @post_detail.file_type = "webm"
              elsif image.inspect.include?("m4v") || image.inspect.include?("M4V")
                @post_detail.file_type = "webm"
              end
              
              # @post_detail.file_type = "p"
              logger.debug("--------------------------file_name=#{image.inspect.include?("jpg")}")
              
              dir_path = "public/pics/#{post_id}"
              FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)
              @post_detail.file_name = "#{@post.id}-#{cnt+1}.#{@post_detail.file_type}"
              image = params[:images][cnt]
              File.binwrite("public/pics/#{post_id}/#{@post_detail.file_name}", image.read)
              cnt += 1
              
              @post_detail.save
              save_flag = true
             }
          
              if save_flag
                flash[:notice] = "Your post saved successfully"
                redirect_to posts_path
              else 
                render new_post_path
              end
          end
      
      
    else
      render new_post_path
    end
      
  end
  
  def show
    # logger.debug("============================= params[:id] = #{params[:id]}")
    @post = Post.find(params[:id])
    @post_details = PostDetail.where(post_id: params[:id])

  end

  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    @post.content = params[:post][:content]
    if @post.save
      flash[:notice] = "Comment successfully updated!"
      redirect_to post_path
    end
  end
  
  def pdedit
    @post_detail = PostDetail.find(params[:id])
  end
  
  def pdupdate
    require 'fileutils'
    @post_detail = PostDetail.find(params[:id])
    logger.debug("-==========================¥=¥== params[:id] = #{params[:id]}")
    @npdfile_name = @post_detail.file_name.split(".")[0]
    
    FileUtils.rm("public/pics/#{@post_detail.post_id}/#{@post_detail.file_name}")
    if params[:post_detail][:file_name].inspect.include?("jpg") || params[:post_detail][:file_name].inspect.include?("JPG")
      @post_detail.file_type ="jpg"
    elsif params[:post_detail][:file_name].inspect.include?("jpeg") || params[:post_detail][:file_name].inspect.include?("JPEG")
      @post_detail.file_type = "jpeg"
    elsif params[:post_detail][:file_name].inspect.include?("png") || params[:post_detail][:file_name].inspect.include?("PNG")
      @post_detail.file_type = "png"
      logger.debug("-=============================== png 1125 ")

    elsif params[:post_detail][:file_name].inspect.include?("mp4") || params[:post_detail][:file_name].inspect.include?("MP4")
      @post_detail.file_type = "mp4"
    elsif params[:post_detail][:file_name].inspect.include?("mov") || params[:post_detail][:file_name].inspect.include?("MOV")
      logger.debug("-=============================== mov ")
      @post_detail.file_type = "mov"
    elsif params[:post_detail][:file_name].inspect.include?("m4v") || params[:post_detail][:file_name].inspect.include?("M4V")
      @post_detail.file_type = "m4v"
    end
    
    @post_detail.file_name = "#{@npdfile_name}.#{@post_detail.file_type}"
    image = params[:post_detail][:file_name]
    File.binwrite("public/pics/#{@post_detail.post_id}/#{@post_detail.file_name}", image.read)
    
    @post_detail.save
    flash[:notice] = "Post successfully replaced!"
    redirect_to "/posts/#{@post_detail.post_id}"
  end


  def destroy
    @post = Post.find(params[:id])
    @post.destroy
      redirect_to posts_path
  end
  
  private 
    def post_params
      params.require(:post).permit(:writer_id, :content).merge(:writer_id => current_user.id)
    end
    
    def post_detail_params
      params.require(:post).permit(:file_name, :post_id)
    end
    
    def ensure_correct_user
      @post = Post.find(params[:id])
      if @post.writer_id != current_user.id
        flash[:notice] = "You have no authority to access"
        redirect_to("/posts")
      end
    end
    
    
end  ## class end


