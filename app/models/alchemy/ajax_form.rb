module Alchemy
  class AjaxForm < ApplicationRecord

    self.abstract_class = true

    def sended!
      @_sended = true
    end

    def sended?
      @_sended === true
    end

    def notify_subject
      I18n.translate(:default_notification_object, scope: [:ajax_form_mailer,:subjects])
    end

    validates :email, :presence => {allow_blank: false}
    validates_format_of :email, :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

    #Mi serve per memorizzare l'elemento alchemy da cui è partita la form, in modo da poter idetificare la mail del destinatario
    attr_accessor :alcm_element

    def mailer
      AjaxFormMailer.notify_message(self)
    end

    def emails_recipient
      element = Alchemy::Element.find(self.alcm_element)
      element.content_by_name(:email_destinatario_notifica).essence.body
    rescue
      EnteBilaterale::EMAIL_NOTIFY
    end

  end
end