# Rails Token Auth

## Set Up
- In `Gemfile` uncomment the lines:
    ```ruby
    # We will need bcrypt for user authentication
    gem 'bcrypt', '~> 3.1.7'
    ```
    and

    ```ruby
    # We will need rack-cors so we can talk to our api from our react app
    gem 'rack-cors'
    ```
- In `config/initializers/cors.rb` we will have to set up our cors. Uncomment the code in the bottom of the file and for now change where it says `origins 'example.com'` to `origins 'http://localhost:3000'`.

    ***NOTE:***
    >Later when you deploy, you will need to change this url to match the server your react app is hosted on.

## Adding Users

#### `rails g model User name:string password:digest email:string auth_token:token` 
- `password:digest` adds a secure password to our model
- `auth_token:token` adds a column that will contain a unique, secure token associated to that user.

#### Migration
```ruby
class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password_digest
      t.string :email
      t.string :auth_token

      t.timestamps
    end
    add_index :users, :auth_token, unique: true
  end
end
```
We created our users table. it automatically made our password into a password digest and created an `index` on the user's auth token. This creates an easy lookup in our databse so we can quickly find our user by the auth token.

#### Model

```ruby
class User < ApplicationRecord
  has_secure_token :auth_token
  has_secure_password
end
```

- `has_secure_token` adds functionality to our model to do with our token. Now our user will have a randomly generated token assigned to them. It will look something like: `pX27zsMN2ViQKta1bGfLmVJE` 
- `has_secure_password` adds functionality to our model regarding the password. It will automatically encrypt the password before adding it to our database. It also gives us a method that authenticates a password.

To make email lookups easier I'm also going to add a method that will make sure an email is lowercase when saved. In the user model:

```ruby
def downcase_email
  self.email = email.downcase if email.present?
end
```

This method will set the email to the lowercase version if it is present. Now we can use this as a model callback before validations:

```ruby
before_validation :downcase_email
```

lets also add a uniqueness validation on the email and a presence validation on all of the attributes

#### Relationship

Lets add a relationship between our cups and users. We can do this by creating a new migration to add the reference to our cups.
```
rails g migration AddUserToCups user:references
```

This will create a new migration:

```ruby
class AddUserToCups < ActiveRecord::Migration[5.2]
  def change
    add_reference :cups, :user, foreign_key: true
  end
end
```

Don't forget to add the relationship to your models as well!

##### Cup
```ruby
belongs_to :user
```

##### User 
```ruby
has_many :cups, dependent: :delete_all
```

#### Routes

|method|route|action|notes|
|-|-|-|-|
|POST|/users|users#create|creates a new user|
|POST|/sessions|sessions#create|validates a user's email/password and returns a token|
|GET|/users/:id|users#show|restrict to user|
|GET|/cups|cups#index|require token and send back the user's cups|

#### Controllers 

**Users#create:** We want a method to create a new user. We can do this how we normally would
```ruby
def create 
  @user = User.create!(user_params)
  render json: @user
end 

def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
```

**Sessions#create:** Here we want a method to log in a user. We want to:
- Find the user by the email they gave (to lowercase) 
- Check to see if the password matches using `@user.authenticate(params[:password])`
- Return the correct user or error

**Application:** We want to create a method that we can use in all of our controllers to require a valid auth token We should:
- Find the user by the `auth_token` param and set it to an instance variable to be able to use later if needed
- If there is no user, send back an error 

**Users#find:** Here we want to send back the user, only if it is their own.
- We should use a before action to require our token
- Check to see if the user id matches the current user's id
- Send back the user if it does

**Cups#index** Here we want to send back the user's cups
- We should require our token
- Use current user to get the cups

