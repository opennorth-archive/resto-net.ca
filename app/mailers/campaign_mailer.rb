class CampaignMailer < ActionMailer::Base
  default from: 'info@opennorth.ca'

  def mapaq(params)
    @name = params[:name]
    @message = params[:message]
    mail params.slice(:cc, :subject).merge(to: 'insert_email@here.com') # @todo
  end
end
