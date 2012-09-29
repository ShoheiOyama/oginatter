class Graph
  def self.create_spline(title, categories, name, data)
    return if title.nil? || categories.blank? || name.nil? || data.blank?
    chart = Graph.create_graph("spline", title, categories, name, data)
    return chart 
  end

  def self.create_column(title, categories, name, data)
    return if title.nil? || categories.blank? || name.nil? || data.blank?
    chart = Graph.create_graph("column", title, categories, name, data)
    return chart 
  end

  def self.create_graph(type, title, categories, name, data)
    return if title.nil? || categories.blank? || name.nil? || data.blank?
    chart = LazyHighCharts::HighChart.new("graph") do |f|
              f.chart(:type => type)
              f.title(:text => title)
              f.xAxis(:categories => categories)
              f.series(:name => name,
                       :data => data)
            end
    return chart
  end
end