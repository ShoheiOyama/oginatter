class FollowController < ApplicationController
  before_filter :validate_login
  before_filter :set_user

  def index
    @follow_users = Follow.get_follow_users(@user)
  end

  def add_list
    @follow_users = Follow.get_follow_users(@user)
  end

  def create_list
    redirect_to :action => :add_list if params[:fids].nil?
    @list_name = params[:list_name]
    new_list = Twitter.list_create(@list_name)
    fids = params[:fids]
    cnt = fids.size / 10
    cnt.times do |num|
      Twitter.list_add_members(new_list['id'], fids[num*10..num*10+9])
    end
    mod = (fids.size % 10) - 1
    Twitter.list_add_members(new_list['id'], fids[cnt*10..cnt*10+mod])
    redirect_to :action => :index
  end
end
