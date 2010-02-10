class InvitationsController < ApplicationController
  before_filter :require_user
  before_filter :require_invitations_to_send
  
  def new
    @invitation = current_user.sent_invitations.build
  end
  
  def create
    @invitation = current_user.sent_invitations.build(params[:invitation])
    if @invitation.save
      @invitation.deliver_invitation!
      flash[:notice] = "Thank you, invitation sent."
      redirect_to brand_results_url
    else
      flash[:error] = "Invitation failed! #{@invitation.errors.on_base}"
      render :action => 'new'
    end
  end
  
  private
    def require_invitations_to_send
      unless current_user.invitation_limit > 0
        flash[:notice] = "You have reached your limit of invitations to send."
        redirect_to brand_results_path
      end
    end
end