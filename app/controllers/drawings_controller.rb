require 'base64'
require 'stringio'

class DrawingsController < ApplicationController
  before_action :set_drawing, only: %i[show edit update destroy]
  before_action :require_login, only: %i[new create edit update]
  before_action :require_owner, only: %i[edit update destroy]

  # GET /drawings or /drawings.json
  def index
    @drawings = Drawing.all
  end

  # GET /drawings/1 or /drawings/1.json
  def show
  end

  # GET /drawings/new
  def new
    @drawing = Drawing.new
  end

  # GET /drawings/1/edit
  def edit
  end

  # POST /drawings or /drawings.json
  def create
    Rails.logger.info "drawing_params: #{drawing_params.inspect}"
    Rails.logger.info "artist: #{current_user.display_name}"
    Rails.logger.info "slack id: #{current_user.slack_id}"

    @drawing = Drawing.new(drawing_params.merge(
                             artist: current_user.display_name,
                             slack_id: current_user.slack_id
                           ))

    if @drawing.save
      redirect_to @drawing, notice: 'DRAWING SUCCESSFULLY CREATED'
    else
      Rails.logger.debug @drawing.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drawings/1 or /drawings/1.json
  def update
    if @drawing.update(drawing_params)
      redirect_to @drawing, notice: 'DRAWING SUCCESSFULLY UPDATED'
    else
      render :edit, status: unprocessable_entity
    end
  end

  # DELETE /drawings/1 or /drawings/1.json
  def destroy
    @drawing.destroy!

    respond_to do |format|
      format.html { redirect_to drawings_path, status: :see_other, notice: 'DRAWING DESTROYED.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_drawing
    @drawing = Drawing.find(params[:id])
  end

  def drawing_params
    params.require(:drawing).permit(:image_url)
  end

  def require_login
    return if session[:user_id]

    redirect_to '/auth/slack', alert: 'YOU MUST LOGIN TO DRAW.'
  end

  def require_owner
    return if current_user.slack_id == @drawing.slack_id || current_user.slack_id == ENV['IDID']

    redirect_to drawings_path, notice: 'NO VANDALISM :3'
  end
end
