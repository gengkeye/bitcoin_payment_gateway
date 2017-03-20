class QrCodeController < ApplicationController
  def show
    size = params[:size].present? ? params[:size].to_i : 180

    in_url = CGI.unescape(params[:id])
    qrcode = RQRCode::QRCode.new(in_url, :level => :l) # useable level: l m q h
    image = qrcode.as_png(size: size,
                          fill: 'white', # ChunkyPNG::Color::TRANSPARENT
                          border_modules: 1)
    send_data image, filename: 'qr_code.png', type: 'image/png', disposition: 'inline'
  end
end
