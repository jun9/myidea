class SolutionsController < ApplicationController
  authorize_resource

  def create
    @solution = Solution.new(params[:solution])
    @solution.user = current_user
    @idea_id = params[:idea_id] 
    @solution.idea = Idea.find(@idea_id)
    @solution.save
  end

  # PUT /solutions/1
  # PUT /solutions/1.json
  def update
    @solution = Solution.find(params[:id])

    respond_to do |format|
      if @solution.update_attributes(params[:solution])
        format.html { redirect_to @solution, notice: 'Solution was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.json
  def destroy
    @solution = Solution.find(params[:id])
    @solution.destroy

    respond_to do |format|
      format.html { redirect_to solutions_url }
      format.json { head :ok }
    end
  end
end
