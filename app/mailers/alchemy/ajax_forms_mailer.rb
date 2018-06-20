module Alchemy
  class AjaxFormsMailer < ApplicationMailer

    layout "alchemy/base_mailer"


    def notify_message(r)
      @rec = r
      mail(to: r.emails_recipient, subject: r.notify_subject)do |format|
        format.mjml { render "notify_message", locals: { recipient: @rec} }
      end
    end

  end
end

