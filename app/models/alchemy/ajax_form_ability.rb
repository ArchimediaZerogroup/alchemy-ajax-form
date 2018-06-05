module Alchemy
  class AjaxFormAbility
    include CanCan::Ability

    def initialize(user)

      if user.present? && user.is_admin?
        # can :manage, ::UserSiteRegistration
        # can :manage, :admin_user_site_registrations

        can :manage, AjaxForm
        cannot :create, AjaxForm
        cannot :update, AjaxForm
        can :manage, :admin_ahjax_forms
        cannot :create, :admin_ajax_forms
        cannot :update, :admin_ajax_forms

      end
    end

  end
end