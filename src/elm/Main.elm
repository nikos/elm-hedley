import App.Model as App exposing (Model)
import App.Router exposing (delta2update, location2action)
import App.Update exposing (init, update)
import App.View exposing (view)
import Effects exposing (Never)
import EventList.Update exposing (Action)
import Pages.Event.Update exposing (Action)
import Leaflet.Model exposing (Model)
import RouteHash
import StartApp as StartApp
import Task exposing (Task)


app =
  StartApp.start
    { init = App.Update.init
    , update = App.Update.update
    , view = App.View.view
    , inputs =
        [ messages.signal
        , Signal.map (App.Update.ChildEventAction << Pages.Event.Update.ChildEventListAction << EventList.Update.SelectEvent) selectEvent
        ]
    }

main =
  app.html

messages : Signal.Mailbox App.Update.Action
messages =
    Signal.mailbox App.Update.NoOp

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

port routeTasks : Signal (Task () ())
port routeTasks =
  RouteHash.start
    { prefix = RouteHash.defaultPrefix
    , address = messages.address
    , models = app.model
    , delta2update = App.Router.delta2update
    , location2action = App.Router.location2action
    }

-- Interactions with Leaflet maps

type alias LeafletPort =
  { leaflet : Leaflet.Model.Model
  , events : List Int
  }

port mapManager : Signal LeafletPort
port mapManager =
  let
    getEvents model =
      (.events >> .events) model

    getLeaflet model =
      (.events >> .leaflet) model

    getLeafletPort model =
      { events = List.map .id <| getEvents model
      , leaflet = getLeaflet model
      }

  in
    Signal.map getLeafletPort app.model

port selectEvent : Signal (Maybe Int)

-- Dropzone

type alias ActivePagePort =
  { accessToken : String
  , activePage : String
  , backendUrl : String
  }

port activePage : Signal ActivePagePort
port activePage =
  let
    pageAsString page =
      case page of
        App.Event _ -> "Event"
        App.GithubAuth -> "GithubAuth"
        App.Login -> "Login"
        App.User -> "User"

    getPortData model =
      { accessToken = model.accessToken
      , activePage = pageAsString model.activePage
      , backendUrl = (.config >> .backendConfig >> .backendUrl) model
      }
  in
    Signal.map getPortData app.model

