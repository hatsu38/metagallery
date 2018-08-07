class InquiryMailer < ApplicationMailer
  def send_mail(inquiry)
    @inquiry = inquiry
    mail(
      from: 'toy.wonder70@gmail.com',
      to:   'toy.wonder70@gmail.com',
      subject: 'お問い合わせ通知 | Cafepedia'
    )
  end
end
