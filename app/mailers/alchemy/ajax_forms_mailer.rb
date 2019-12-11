module Alchemy
  class AjaxFormsMailer < ApplicationMailer

    if Alchemy::Ajax::Form.enable_mjml
      layout "alchemy/mjml_base_mailer"
    else
      layout "alchemy/base_mailer"
    end


    include Alchemy::ConfigurationMethods
    add_template_helper(Alchemy::PagesHelper)


    def notify_message(r)
      @rec = r
      reply_to = @rec.email if @rec.respond_to? :email
      if Alchemy::Ajax::Form.enable_mjml
        mail(from: Alchemy::EMAIL_NOTIFY_FROM, to: r.emails_recipient, subject: r.notify_subject, reply_to: reply_to) do |format|
          format.mjml { render "mjml_notify_message", locals: {recipient: @rec} }
        end
      else
        mail(from: Alchemy::EMAIL_NOTIFY_FROM, to: r.emails_recipient, subject: r.notify_subject, reply_to: reply_to)
      end
    end

    def notify_message_user(r)
      @rec = r
      if Alchemy::Ajax::Form.enable_mjml
        mail(to: @rec.email, from: Alchemy::EMAIL_NOTIFY_FROM, subject: @rec.notify_user_subject) do |format|
          format.mjml { render "mjml_notify_user_message", locals: {recipient: @rec} }
        end
      else
        mail(to: @rec.email, from: Alchemy::EMAIL_NOTIFY_FROM, subject: @rec.notify_user_subject) do |format|
          format.html {render "notify_user_message"}
        end
      end
    end

  end
end

