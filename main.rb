require 'httparty'
require 'securerandom'
require 'thread'
require 'optparse'
require 'uri'
require 'cgi'

def display_logo # Define a method to display the logo
  logo = <<-LOGO
  
     ... [ create by Maven watch yourself ] ...
     ... [ version 2.0 ] ...
  LOGO
  puts logo
end

def request_and_print(url, path, use_ssl, timeout, total_checked, found_count)
    encoded_path = CGI.escape(path)
    full_url = "#{url}#{encoded_path}"
    response = HTTParty.get(full_url, verify: use_ssl, timeout: timeout)
    
    total_checked[0] += 1

    response_code = response.code
    response_size = response.body.length
    status_info = "(CODE:#{response_code}|SIZE:#{response_size})"

    if response.success?
        # طباعة الطلبات الناجحة على سطر جديد
        puts "\r+ #{full_url} #{status_info}"
        found_count[0] += 1
        STDOUT.flush
    else
        # طباعة "Checking" في نفس السطر
        print "\rChecking: #{full_url}#{' ' * 20}"  # إضافة مسافات لتنظيف النص القديم
        STDOUT.flush
    end

rescue StandardError 
end


def random_string_mode(url, use_ssl, count, timeout) # Method for random string mode with threading
    total_checked = [0]  # Use an array to allow modification inside threads
    found_count = [0]
    threads = []
    count.times do
        threads << Thread.new do
            random_path = SecureRandom.hex  # Define a unique random path for each thread
            request_and_print(url, path, use_ssl, timeout, total_checked, found_count)
        end
    end
    threads.each(&:join)
    return total_checked[0], found_count[0]  # Return the counts
end

MAX_THREADS = 1  # Adjust this number based on your system's capabilities

def wordlist_mode(url, use_ssl, timeout)
    total_checked = [0]
    found_count = [0]
    threads = []

    list = File.join(__dir__, "wordlist.txt")

    File.foreach(list) do |line|
        path = line.chomp
        next if path.strip.empty?

        threads << Thread.new do
            request_and_print(url, path, use_ssl, timeout, total_checked, found_count)
        end

        if threads.size >= MAX_THREADS
            threads.each(&:join)
            threads = []
        end
    end

    threads.each(&:join)
    return total_checked[0], found_count[0]
end

options = {
    mode: nil,
    url: nil,
    count: 10, # Default value for random string mode
    timeout: 5  # Default timeout in seconds
}

opt_parser = OptionParser.new do |opts| # Define OptionParser
  opts.banner = "Usage: script.rb [options]"

  opts.on("-m", "--mode MODE", "Select mode: 'random' or 'wordlist'") do |m|
    options[:mode] = m
  end

  opts.on("-u", "--url URL", "The target URL with http/https") do |url|
    options[:url] = url
  end

  opts.on("-c", "--count COUNT", Integer, "Number of random strings (default: 10)") do |count|
    options[:count] = count
  end

  opts.on("-t", "--timeout TIMEOUT", Integer, "Timeout of requests (default: 0)") do |timeout|
    options[:timeout] ||= 5  # Default timeout of 5 seconds
  end

  opts.on("-h", "--help", "Write this help for more info") do
    puts opts
    exit
  end
end

opt_parser.parse!

unless options[:mode] && options[:url] # Validate required options
    puts "Missing required arguments"
    puts opt_parser
    exit
end

options[:url] += '/' unless options[:url].end_with?('/') # Ensure the URL ends with a slash

display_logo # print logo & then Main execution

use_ssl = options[:url].include?("https://")

start_time = Time.now
puts "\n\nSTART_TIME: #{start_time}"
puts "URL_BASE: #{options[:url]}"
puts "WORDLIST_FILE: #{File.join(__dir__, 'wordlist.txt')}\n\n"

puts ""

case options[:mode]
when "random"
  total_checked, found_count = random_string_mode(options[:url], use_ssl, options[:count], options[:timeout])
when "wordlist"
  total_checked, found_count = wordlist_mode(options[:url], use_ssl, options[:timeout])
else
  puts "Invalid mode. Use 'random' or 'wordlist'."
end

end_time = Time.now
puts "\nEND_TIME: #{end_time}"
puts "DOWNLOADED: #{total_checked} - FOUND: #{found_count}"