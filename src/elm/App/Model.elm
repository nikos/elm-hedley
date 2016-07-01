module App.Model where

import Config.Model as Config exposing (initialModel, Model)
import Company.Model as Company exposing (Model)

-- Pages import

import Pages.Event.Model as Event exposing (initialModel, Model)
import Pages.GithubAuth.Model as GithubAuth exposing (Model)
import Pages.Login.Model as Login exposing (initialModel, Model)
import Pages.User.Model as User exposing (initialModel, Model)

type alias AccessToken = String
type alias CompanyId = Int

type Page
  = Event (Maybe CompanyId)
  | GithubAuth
  | Login
  | User

type alias Model =
  { accessToken : AccessToken
  , activePage : Page
  , config : Config.Model
  , configError : Bool
  , companies : List Company.Model
  , events : Event.Model
  , githubAuth: GithubAuth.Model
  , login: Login.Model
  -- If the user is anonymous, we want to know where to redirect them.
  , nextPage : Maybe Page
  , user : User.Model
  }

initialModel : Model
initialModel =
  { accessToken = ""
  , activePage = Login
  , config = Config.initialModel
  , configError = False
  , companies = []
  , events = Event.initialModel
  , githubAuth = GithubAuth.initialModel
  , login = Login.initialModel
  , nextPage = Nothing
  , user = User.initialModel
  }
