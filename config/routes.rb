Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "users#index"

  get("/", controller: "users", action: "index")
  get("/users", controller: "users", action: "index")
  get("/users/sign_out", controller: "users", action: "destroy")
  #get("/users/:username", controller: "users", action: "show")
  #post("/add_user", controller: "users", action: "create")
  #post("/update_user/:user_id", controller: "users", action: "update")


  get("/photos", controller: "photos", action: "index")
  get("/photos/:photo_id", controller: "photos", action: "show")
  get("/delete_photo/:photo_id", controller: "photos", action: "delete")
  post("/insert_photo_record", controller: "photos", action: "create")
  post("/update_photo/:photo_id", controller: "photos", action: "update")
  post("/add_comment", controller: "photos", action: "comment")
end
