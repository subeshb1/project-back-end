# frozen_string_literal: true

# All authorization module for user with core role
module CoreAbility
  def job_provider(user)
    can :manage, :all
    cannot :create_core_user, User
    can :download_report, User
    can :manage_downloads, User, uid: user.uid
    can :upload_activity_data, User
    can :report_delivery_hub_issue, User
    can :view_schedules_exceptions, User
    can :view_internal_dashboard, User
    can :update_capacity_distribution, User
    can :view_capacity_distribution, User

    cannot :report_manual_time, User
    can :review_time_reports, User

    # banks and bankaccounts
    can :configure_bank_account, User

    # Identification Documents
    can :configure_identification_document, User
  end
end
