require 'sinatra'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'json'
require 'httparty'

class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  # Add your routes here
  get "/" do
    { message: "Good luck with your project!" }.to_json
  end

  get "/recipes" do 
  ingredient = params[:ingredient]
  recipes = Recipe.where("name LIKE ?", "%#{ingredient}%")
  recipes.to_json
  end



  get "/recipes/:id" do 
    recipe = Recipe.find_by(id: params[:id])

    if recipe
      {
        id: recipe.id_meal,
        name: recipe.name,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        str_meal_thumb: recipe.str_meal_thumb
      }.to_json
    else
      status 404
      { error: 'Recipe not found' }.to_json
    end
  end

  get "/recipes/:id/video" do 
    recipe = Recipe.find_by(id_meal: params[:id])

    if recipe
      videos = Video.where(recipe_id: params[:id])
      videos.to_json
    else
      status 404
      { error: 'Recipe not found' }.to_json
    end
  end

  not_found do 
    status 404
    { error: "Not found" }.to_json
  end


  #Update operations

  post "/recipes/:id/favourites" do
    recipe = Recipe.find_by(id: params[:id])

    if recipe
      favourite = Favourite.create(recipe_id: recipe.id)
      favourite.save
      favourite.json
      {message: "Recipe saved as favorite."}.to_json
    else
      status 404
      {error: "Recipe not found."}.to_json
    end
  end

  put "/recipes/:id/notes" do
    recipe = Recipe.find_by(id: params[:id])

    if recipe
      note = Note.find_or_create_by(recipe_id: recipe.id)
      note.update(notes: params[:notes])

      {message: "Notes updated successfully."}.to_json
    end
  end
end
