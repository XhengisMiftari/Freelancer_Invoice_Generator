WickedPdf.config = {
  exe_path: begin
    if Rails.env.production?
      '/app/bin/wkhtmltopdf' # wkhtmltopdf-heroku sets this path
    else
      Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
    end
  end
  enable_local_file_access: true
}
