defmodule Caravan.Router do
  use Caravan.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Caravan.CurrentUser
  end

  pipeline :browser_authenticated do
    plug Guardian.Plug.EnsureAuthenticated, handler: Caravan.BrowserAuthHandler
  end

  scope "/", Caravan do
    pipe_through [:browser, :with_session]

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/users", UserController, only: [:new, :create]
  end

  scope "/", Caravan do
    pipe_through [:browser, :with_session, :browser_authenticated]

    get "/", PageController, :index
    resources "/users", UserController, except: [:new, :create]
    resources "/bills", BillController
    resources "/bill_items", BillItemController, except: [:index]
    resources "/bill_members", BillMemberController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Caravan do
  #   pipe_through :api
  # end
end
