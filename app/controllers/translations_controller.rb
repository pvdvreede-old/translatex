# controller to list and manipulate translations by the
# current user
class TranslationsController < ApplicationController

  # GET /translations
  def index
    @translations = current_user.translations.page(params[:page]).per(10)

    respond_to do |format|
      format.html
    end
  end

  # GET /translations/new
  def new
    @translation = Translation.new

    respond_to do |format|
      format.html
    end
  end

  # GET /translations/1/edit
  def edit
    begin
      @translation = current_user.translations.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      not_found
    end
  end

  # POST /translations/new
  def create
    @translation = Translation.new(params[:translation])
    @translation.user = current_user

    respond_to do |format|
      if @translation.save
        format.html do
          redirect_to(
            translations_path,
            :notice => 'Translation was successfully created.'
          )
        end
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /translations/1
  def update
    begin
      @translation = current_user.translations.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      not_found
    end

    respond_to do |format|
      if @translation.update_attributes(params[:translation])
        format.html do
          redirect_to(
            translations_path,
            :notice => 'Translation was successfully updated.'
          )
        end
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /translations/1
  # DELETE /translations/1.json
  def destroy
    @translation = Translation.find(params[:id])
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to translations_url }
      format.json { head :no_content }
    end
  end
end
