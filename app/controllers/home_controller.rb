class HomeController < ApplicationController
  def index
    if current_user
      @user = Twitter.user
      @timelines = Twitter.user_timeline(@user.screen_name, :count => 200)
      @reply_map = {}
      @timelines.each do |timeline|
        unless timeline.in_reply_to_screen_name.nil?
          if @reply_map[timeline.in_reply_to_screen_name].nil?
            @reply_map[timeline.in_reply_to_screen_name] = 1
          else
            @reply_map[timeline.in_reply_to_screen_name] += 1
          end
        end
      end
      unless @reply_map.blank?
        @reply_map = @reply_map.to_a.sort{|a, b|
          (b[1] <=> a[1]) * 2 + (a[0] <=> b[0])
        }.slice(0,10)
      end
    end
  end
end
