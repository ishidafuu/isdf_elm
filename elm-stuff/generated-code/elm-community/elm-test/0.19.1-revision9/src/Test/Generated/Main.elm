module Test.Generated.Main exposing (main)

import RouteTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = JsonReport
        , seed = 223279568649110
        , processes = 8
        , globs =
            []
        , paths =
            [ "/Users/ishida/Documents/isdf_elm/tests/RouteTest.elm"
            ]
        }
        [ ( "RouteTest"
          , [ Test.Runner.Node.check RouteTest.suite
            ]
          )
        ]