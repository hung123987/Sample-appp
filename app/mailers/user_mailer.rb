class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email,
    subject: I18n.t("user_mailer.password_reset.account_activation")
  end

  def password_reset user
    @user = user
    mail to: user.email,
    subject: I18n.t("user_mailer.password_reset.password_reset")
  end
end
