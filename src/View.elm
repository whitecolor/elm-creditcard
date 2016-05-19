module View exposing (view)

{-| View
-}

import Model exposing (Model, Options, Field)
import Html exposing (Html, div, text, input, button, label)
import Html.Attributes exposing (class, type', id, value, placeholder)
import Html.Events exposing (onInput)
import Html.App as App
import Update exposing (Msg(..))
import Components.NumberInput as NumberInput exposing (numberInput)
import Components.Card exposing (viewCard)


view : Model -> Html Msg
view model =
    div [ class "elm-card" ]
        [ viewCard model
        , App.map UpdateNumber (viewIntField model.options { maxLength = Just 16, maxValue = Nothing, minValue = Nothing } model.number)
        , viewField UpdateName model.options model.name
        , App.map UpdateExpirationMonth (viewIntField model.options { maxLength = Just 2, maxValue = Just 12, minValue = Just 1 } model.expirationMonth)
        , App.map UpdateExpirationYear (viewIntField model.options { maxLength = Just 4, maxValue = Nothing, minValue = Nothing } model.expirationYear)
        , App.map UpdateCCV (viewIntField model.options { maxLength = Just 4, maxValue = Nothing, minValue = Nothing } model.ccv)
        ]


viewField : (String -> Msg) -> Options -> Field String -> Html Msg
viewField tagger options field =
    div []
        [ viewLabel options field
        , input [ placeholder options field, onInput tagger, value (field.value |> Maybe.withDefault "") ] []
        ]


viewIntField : Options -> NumberInput.Options -> Field Int -> Html NumberInput.Msg
viewIntField options numberInputOptions field =
    div []
        [ viewLabel options field
        , numberInput numberInputOptions
            identity
            [ placeholder options field ]
            (field.value |> Maybe.map toString |> Maybe.withDefault "")
        ]


viewLabel : Options -> Field a -> Html msg
viewLabel options field =
    if options.showLabel then
        field.label
            |> Maybe.map (\labelText -> label [] [ text labelText ])
            |> Maybe.withDefault (text "")
    else
        text ""


placeholder options field =
    if options.showLabel then
        Html.Attributes.placeholder ""
    else
        field.label
            |> Maybe.map Html.Attributes.placeholder
            |> Maybe.withDefault (Html.Attributes.placeholder "")