require "redis"
require "json"
require 'fileutils'
#require 'speech_to_text'

redis = if ENV['REDIS_URL'].nil?
          Redis.new
        else
          Redis.new(url: ENV['REDIS_URL'])
        end

RECORDINGS_JOB_LIST_KEY = "bbb_playback:playback_job"
puts RECORDINGS_JOB_LIST_KEY
num_entries = redis.llen(RECORDINGS_JOB_LIST_KEY)
puts "num_entries = #{num_entries}"
loop do
  # for i in 1..num_entries do
  _list, element = redis.blpop(RECORDINGS_JOB_LIST_KEY)
  job_entry = JSON.parse(element)
  puts job_entry
    
  record_id = job_entry["record_id"]
  vtt_file = job_entry["vtt_file"]
  json_file = job_entry["json_file"]
  inbox_dir = "#{job_entry['captions_inbox_dir']}/inbox"
  #local_presentation_dir = "/D/innovation/text-track-service/captions_test"
  presentation_dir = "/var/bigbluebutton/published/presentation"
  caption_locale = job_entry["caption_locale"]
    
  FileUtils.cp("#{inbox_dir}/#{vtt_file}",
               "#{presentation_dir}/caption_#{caption_locale}",
               verbose: true)
    
  def captions_json(file_path:,
                    file_name:,
                    localeName:,
                    locale:)
      captions_file_name = "#{file_path}/#{file_name}"
      captions_file = File.open(captions_file_name,"w")
      captions_file.puts "[{\"localeName\": \"#{localeName}\", \"locale\": \"#{locale}\"}]"
      captions_file.close
  end
    
  captions_json(
    file_path: inbox_dir,
    file_name: "captions.json",
    localeName: "English (United States)",
    locale: caption_locale
  )
end