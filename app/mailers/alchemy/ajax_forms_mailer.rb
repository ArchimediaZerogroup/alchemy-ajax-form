module Alchemy
  class AjaxFormsMailer < ApplicationMailer


    def notify_message(r)
      @rec = r
      mail(to: r.emails_recipient, subject: r.notify_subject)
    end

  end
end

