class InvitationsController < ApplicationController
  before_filter :require_user
  
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
end