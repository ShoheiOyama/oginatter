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
      @end_at = Date.today
      @start_at = @end_at - 6
      @categories = @start_at.upto(@end_at).to_a
      @data = [5, 6, 3, 1, 2, 4, 7]

      @h = LazyHighCharts::HighChart.new("graph") do |f|
        f.chart(:type => "column")
        f.title(:text => "Sample graph")
        f.xAxis(:categories => @categories)
        f.series(:name => "sample",
                 :data => @data)
      end
    end
  end
end
