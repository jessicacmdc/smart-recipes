class RecipesController < ApplicationController
  before_action :set_recipe, only: [ :show, :edit, :destroy ]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
    find_category_image(@recipe.category)
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to recipe_path(@recipe), notice: 'recipe was successfully created.'
    else
      @recipes = @recipe.recipes
      render "recipes/show", status: :unprocessable_entity
    end
  ;end

  def edit;end

  def destroy
    @recipe.destroy
    redirect_to recipe_path(@recipe), status: :see_other
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

   def recipe_params
    params.require(:recipe).permit(:title, :ingredients, :instruction, :category, :required_time, :serves)
  end

    def find_category_image(category)
    @category_img = case category
     when "Breakfast & Brunch"
        "https://shorturl.at/ZCwFX"
      when "Lunch & Dinner"
        "https://shorturl.at/1dxIn"
      when "Appetizers & Snacks"
        "https://shorturl.at/2gDh0"
      when "Salad"
        "Salads & Sides"
      else
        "https://shorturl.at/wPVwf"
      end
  end
end
