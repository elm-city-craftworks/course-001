require_relative "ruby_ls/file_details"
require_relative "ruby_ls/listing"

module RubyLS
  def self.match_files(params, success_callback, failure_callback) 
    dir_listing  = params[:files].empty? ||
                   (params[:files].length == 1 && File.directory?(params[:files][0]))

    working_dir = dir_listing ? (params[:files][0] || ".") : "."

    Dir.chdir(working_dir) do
      if dir_listing 
        files = params[:all_files] ? Dir.entries(".") : Dir.glob("*")
      else
        files = params[:files]
      end
     
      files.each do |f|
        return failure_callback.call(f) unless File.exist?(f)
      end

      details = files.map { |e| FileDetails.new(e) }
      success_callback.call(Listing.new(details), dir_listing)
    end
  end
end
