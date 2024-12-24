module REGL.Program exposing (..)

import Json.Encode as Encode exposing (Value)


type ProgValue
    = DynamicValue String
    | StaticValue Value
    | DynamicTextureValue String -- Dynamic texture value


type Primitive
    = Points
    | Lines
    | LineLoop
    | LineStrip
    | Triangles
    | TriangleStrip
    | TriangleFan


type alias REGLProgram =
    { frag : String
    , vert : String
    , attributes : Maybe (List ( String, ProgValue ))
    , uniforms : Maybe (List ( String, ProgValue ))
    , elements : Maybe (List Int)
    , primitive : Maybe Primitive
    , count : Int
    }


maybeToList : Maybe a -> List a
maybeToList x =
    case x of
        Just a ->
            [ a ]

        Nothing ->
            []


primitiveToValue : Primitive -> Value
primitiveToValue p =
    case p of
        Points ->
            Encode.string "points"

        Lines ->
            Encode.string "lines"

        LineLoop ->
            Encode.string "line loop"

        LineStrip ->
            Encode.string "line strip"

        Triangles ->
            Encode.string "triangles"

        TriangleStrip ->
            Encode.string "triangle strip"

        TriangleFan ->
            Encode.string "triangle fan"


getDynamicValue : List ( String, ProgValue ) -> List ( String, Value )
getDynamicValue x =
    List.filterMap
        (\( k, v ) ->
            case v of
                DynamicValue s ->
                    Just ( k, Encode.string s )

                _ ->
                    Nothing
        )
        x


getDynamicTextureValue : List ( String, ProgValue ) -> List ( String, Value )
getDynamicTextureValue x =
    List.filterMap
        (\( k, v ) ->
            case v of
                DynamicTextureValue s ->
                    Just ( k, Encode.string s )

                _ ->
                    Nothing
        )
        x


getStaticValue : List ( String, ProgValue ) -> List ( String, Value )
getStaticValue x =
    List.filterMap
        (\( k, v ) ->
            case v of
                StaticValue s ->
                    Just ( k, s )

                _ ->
                    Nothing
        )
        x


encodeProgram : REGLProgram -> Value
encodeProgram p =
    Encode.object <|
        [ ( "frag", Encode.string p.frag )
        , ( "vert", Encode.string p.vert )
        , ( "count", Encode.int p.count )
        ]
            ++ (maybeToList <|
                    Maybe.map (\x -> ( "elements", Encode.list Encode.int x )) p.elements
               )
            ++ (maybeToList <|
                    Maybe.map (\x -> ( "primitive", primitiveToValue x )) p.primitive
               )
            ++ (maybeToList <|
                    Maybe.map (\x -> ( "attributes", Encode.object (getStaticValue x) )) p.attributes
               )
            ++ (maybeToList <|
                    Maybe.map (\x -> ( "attributesDyn", Encode.object (getDynamicValue x) )) p.attributes
               )
            ++ (maybeToList <|
                    Maybe.map (\x -> ( "uniforms", Encode.object (getStaticValue x) )) p.uniforms
               )
            ++ (maybeToList <|
                    Maybe.map (\x -> ( "uniformsDyn", Encode.object (getDynamicValue x) )) p.uniforms
               )
            ++ (maybeToList <|
                    Maybe.map (\x -> ( "uniformsDynTexture", Encode.object (getDynamicTextureValue x) )) p.uniforms
               )
