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
    pp fids
    pp new_list
    cnt = fids.size / 10
    i = 0
    cnt.times do |num|
      Twitter.list_add_members(new_list['id'], fids[i..i+9])
      i = i + 10
    end
    mod = (fids.size % 10) - 1
    Twitter.list_add_members(new_list['id'], fids[i..i+mod])
    redirect_to :action => :index
  end
end
