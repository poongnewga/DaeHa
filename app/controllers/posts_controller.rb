class PostsController < ApplicationController
  def index
  end

  def readmoreposts
    @p_id = params[:p_id]
    @post = Post.find_by(p_id: @p_id)
  end

  def readmorecommentone
    @c_id = params[:c_id]
    @post = Post.find_by(c1_id: @c_id)
  end

  def readmorecommenttwo
    @c_id = params[:c_id]
    @post = Post.find_by(c2_id: @c_id)
  end

  # /posts/total ==> 루트 페이지
  def total
    @url = "total"
    @page = params[:page]
      if @page == nil
        @page = 0
      end
    @posts = Post.all.order(p_time: :desc).limit(4).offset(@page.to_i * 4)
  end

  # /posts/best
  def best
    @url = "best"
    @page = params[:page]
      if @page == nil
        @page = 0
      end
    @posts = Post.all.order(p_reactions_count: :desc).limit(4).offset(@page.to_i * 4)

    render 'total'
  end

  # /posts/search
  def search
    @url = "search"
    @page = params[:page]
    @posts = nil
    @search = params[:search]

    if @search == ""
      @posts = nil
    elsif @search
      @posts = Post.search(@search).order("created_at ASC").limit(4).offset(@page.to_i * 4)
    end
  end
end
