module Alchemy
  class AjaxForm < ApplicationRecord

    self.abstract_class = true

    belongs_to :language, class_name: "Alchemy::Language", optional: true, required: false

    def site
      language.try(:site)
    end


    def notify_subject
      I18n.translate(:default_notification_subject, scope: [:ajax_form_mailer, :subjects])
    end

    def notify_user_subject
      I18n.translate(:default_notification_user_subject, scope: [:ajax_form_mailer, :subjects])
    end

    validates :email, :presence => {allow_blank: false}, if: -> {respond_to? :email}
    validates_format_of :email, :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                        if: -> {respond_to? :email}

    #with alchemy element can retrieve settings of form (ex. recipient_notification)
    attr_accessor :alcm_element

    before_save -> {self.language = Alchemy::Language.current}

    def send_only?
      element_alchemy.content_by_name(:send_only).essence.value
    rescue
      false
    end

    def send_to_staff?
      element_alchemy.content_by_name(:send_staff).essence.value
    rescue
      false
    end

    def send_to_user?
      element_alchemy.content_by_name(:send_user).essence.value and respond_to? :email
    rescue
      false
    end

    def mail_deliver
      if send_to_staff?
        AjaxFormsMailer.notify_message(self).deliver_now
      end
      if send_to_user?
        AjaxFormsMailer.notify_message_user(self).deliver_now
      end
    end

    def element_alchemy
      Alchemy::Element.find(self.alcm_element)
    end

    def emails_recipient
      element_alchemy.content_by_name(:recipient_notification).essence.body
    rescue
      Alchemy::EMAIL_NOTIFY
    end

  end
end