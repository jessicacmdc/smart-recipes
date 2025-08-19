class RecipesController < ApplicationController
  before_action :set_recipe, only: [ :show, :edit, :destroy ]

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
