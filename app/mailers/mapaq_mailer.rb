# -*- encoding : utf-8 -*-
class MapaqMailer < ActionMailer::Base

  def mail(cc, message, subject, name)
    @user_name = name
    @message = message
    mail(:to => 'insert_email@here.com', :cc => cc, :from => 'info@opennorth.ca', :subject => subject) do |format|
      format.text
    end
  end
end
