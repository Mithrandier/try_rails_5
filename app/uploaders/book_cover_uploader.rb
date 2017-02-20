class BookCoverUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  storage :file
  # storage :fog

  def store_dir
    "tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
     process resize_to_fit: [250, 370]
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
   def default_url
     # For Rails 3.1+ asset pipeline compatibility:
     # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

     ActionController::Base.helpers.asset_path('cover_placeholder.png')
   end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end