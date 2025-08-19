class RecipesController < ApplicationController
  before_action :set_recipe, only: [ :show, :destroy ]

  def create
   # THE AI will create this

    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      # render :new, status: :unprocessable_entity
    end
  end


  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def edit;end

  def destroy
    @recipe.destroy
    redirect_to recipe_path(@recipe), status: :see_other

  end

  private

    def set_recipe
    @recipe = Recipe.find(params[:id])
  end

end



  # def review_params
  #   params.require(:review).permit(:content)
  # end
