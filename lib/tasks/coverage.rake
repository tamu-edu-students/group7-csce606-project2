# lib/tasks/coverage.rake
namespace :coverage do
  desc "Display summarized SimpleCov coverage results (manually collated)"
  task :show do
    require 'json'
    coverage_dir = Rails.root.join('coverage')
    result_files = Dir[coverage_dir.join('.resultset*.json')]

    if result_files.empty?
      puts "⚠️  No SimpleCov result files found."
      puts "💡 Run RSpec and Cucumber first."
      exit 0
    end

    puts "\n📊 SimpleCov Coverage Summary"
    puts "------------------------------------"
    percentages = []

    result_files.each do |file|
      data = JSON.parse(File.read(file)) rescue next
      data.each do |command, result|
        percent = result.dig('result', 'covered_percent')
        lines   = result.dig('result', 'covered_lines')
        total   = result.dig('result', 'total_lines')
        next unless percent
        percentages << percent
        puts "🧪 #{command}: #{percent.round(2)}% (#{lines}/#{total} lines)"
      end
    end

    unless percentages.empty?
      avg = percentages.compact.sum / percentages.size
      puts "------------------------------------"
      puts "📈 Combined Coverage (Avg): #{avg.round(2)}%"
    end
  end
end
