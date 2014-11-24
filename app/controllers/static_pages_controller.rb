class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      if @feed_items 
         puts "******************************** feed_items not nil"
      else
         puts "******************************** feed_items nil"
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
