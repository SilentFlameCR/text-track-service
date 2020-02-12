require "rest-client"
require 'jwt'

def upload_vtt
	puts "uploading vtt..."
	record_id = '6e35e3b2778883f5db637d7a5dba0a427f692e91-1572362505303'
	site = 'http://ritz-tts3.freddixon.ca'
	bbb_secret = 'HihnjRgWRhEjWWFG4YyKStyJKmN2dnDRdmPsqdAfo'
	kind = 'subtitles'
	lang = 'en_US'
	label = 'English'
	request = "putRecordingTextTrackrecordID=#{record_id}&kind=#{kind}&lang=#{lang}&label=#{label}"
	request += bbb_secret
	checksum = Digest::SHA1.hexdigest(request)
	tts_secret = 'egUE@IY@&*h82uiohEN@H$*orhdo8234hO@HoH$@ORHF$*r@W'
	payload = { :bbb_url => site, 
	            :bbb_checksum => checksum, 
	            :kind => kind,
	            :label => label,
	            :caption_locale => lang
	          }
	token = JWT.encode payload, tts_secret, 'HS256'
	#response = RestClient.get "http://localhost:4000/caption/#{meeting_id}/en-US", {:params => {:site => "https://#{site}", :checksum => "#{checksum}"}}
	request = RestClient::Request.new(
	    method: :post,
	    url: "http://localhost:4000/edit/uploadvtt/#{record_id}",
	    payload: { :file => File.open('/Users/rahulrodrigues/Desktop/harddrive/D/innovation/text-track-service/storage/6e35e3b2778883f5db637d7a5dba0a427f692e91-1572466783461/captions_en-US.vtt', 'rb'),
	    :token => token}
	)
	response = request.execute
end

def download_vtt
	puts "downloading vtt..."
  record_id = '6e35e3b2778883f5db637d7a5dba0a427f692e91-1572362505303'
  bbb_secret = 'HihnjRgWRhEjWWFG4YyKStyJKmN2dnDRdmPsqdAfo'
  request = "getRecordingTextTracksrecordID=#{record_id}#{bbb_secret}"
  checksum = Digest::SHA1.hexdigest("#{request}")
  site = 'http://ritz-tts3.freddixon.ca'
  tts_secret = 'egUE@IY@&*h82uiohEN@H$*orhdo8234hO@HoH$@ORHF$*r@W'
	payload = { :bbb_url => site, 
	            :bbb_checksum => checksum
	          }
	token = JWT.encode payload, tts_secret, 'HS256'
	#response = RestClient.get "http://localhost:4000/caption/#{meeting_id}/en-US", {:params => {:site => "https://#{site}", :checksum => "#{checksum}"}}
	request = RestClient::Request.new(
	    method: :post,
	    url: "http://localhost:4000/edit/downloadvtt/#{record_id}",
	    payload: {:token => token}
	)
	response = request.execute
	puts response
end

def download_audio
  puts "downloading audio..."
  record_id = '6e35e3b2778883f5db637d7a5dba0a427f692e91-1572362505303'
  bbb_secret = 'HihnjRgWRhEjWWFG4YyKStyJKmN2dnDRdmPsqdAfo'
  request = "getRecordingsrecordID=#{record_id}"
  request = request + bbb_secret
  checksum = Digest::SHA1.hexdigest("#{request}")
  site = 'http://ritz-tts3.freddixon.ca'
  tts_secret = 'egUE@IY@&*h82uiohEN@H$*orhdo8234hO@HoH$@ORHF$*r@W'
	payload = { :bbb_url => site, 
	            :bbb_checksum => checksum
	          }
	token = JWT.encode payload, tts_secret, 'HS256'
	request = RestClient::Request.new(
	    method: :post,
	    url: "http://localhost:4000/edit/downloadaudio/#{record_id}",
	    payload: {:token => token}
	)
	response = request.execute
	File.open("/Users/rahulrodrigues/Desktop/harddrive/D/innovation/text-track-service/storage/downloaded_audio.wav", 'wb') do |f|
      f.write response.body
    end
end
upload_vtt
#download_vtt
#download_audio