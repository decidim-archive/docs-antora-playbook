let Map = https://prelude.dhall-lang.org/Map/Type

let Robots = < allow | disallow | Custom : Text >

let Site =
      { title : Text
      , url : Text
      , start_page : Optional Text
      , keys : Optional (Map Text Text)
      , robots : Optional Robots
      }

let Content =
      { branches : Optional (List Text)
      , sources :
          List
            { url : Text
            , branches : Optional (List Text)
            , tags : Optional (List Text)
            , start_path : Optional Text
            }
      }

let Asciidoc =
      Optional
        { attributes : Optional (Map Text Text)
        , extensions : Optional (List Text)
        }

let Ui =
      { bundle :
          { url : Text, snapshot : Optional Bool, start_path : Optional Text }
      , default_layout : Optional Text
      , output_dir : Optional Text
      , supplemental_files : Optional Text
      }

let Output =
      Optional
        { clean : Optional Bool
        , dir : Optional Text
        , destinations : List { provider : Text }
        }

let Runtime = Optional { cache_dir : Optional Text, fetch : Optional Bool }

let Playbook =
      { site : Site
      , content : Content
      , asciidoc : Asciidoc
      , ui : Ui
      , output : Output
      , runtime : Runtime
      }

in  { Playbook, Site, Content, Asciidoc, Ui, Output, Runtime, Robots }
