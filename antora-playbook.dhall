let Prelude = https://prelude.dhall-lang.org/package.dhall

let Map = https://prelude.dhall-lang.org/Map/Type

let Playbook = ./antora-playbook-schema.dhall

let reposDir = Some env:REPOS_DIR as Text ? None Text

let Branch = < Master | Other : Text >

let site =
      { title = "Decidim Docs"
      , url =
          merge
            { Some = λ(_ : Text) → "http://localhost:5500/build/site/"
            , None = "https://docs.decidim.org"
            }
            reposDir
      , start_page = Some "decidim:ROOT:index.adoc"
      , keys = None (Map Text Text)
      }

let branchesDefault = None (List Text)

let languageDefault =
      { branches = Some [ Branch.Master ], tags = None (List Text) }

let sources
    : List
        { name : Text
        , languages :
            List
              { name : Text
              , branches : Optional (List Branch)
              , tags : Optional (List Text)
              }
        }
    = [ { name = "docs-base"
        , languages = [ languageDefault ⫽ { name = "en" } ]
        }
      ]

let ui =
      { bundle =
        { snapshot = Some True
        , start_path = None Text
        , url =
            merge
              { Some = λ(dir : Text) → "${dir}/docs-ui.git/build/ui-bundle.zip"
              , None =
                  "https://gitlab.com/antora/antora-ui-default/-/jobs/artifacts/master/raw/build/ui-bundle.zip?job=bundle-stable"
              }
              reposDir
        }
      , default_layout = None Text
      , output_dir = None Text
      , supplemental_files = Some "./supplemental_ui"
      }

let asciidoc =
      Some
        { attributes = Some
          [ { mapKey = "idseparator", mapValue = "-" }
          , { mapKey = "xrefstyle", mapValue = "short" }
          , { mapKey = "idprefix", mapValue = "" }
          ]
        , extensions = None (List Text)
        }

let output =
      None
        { clean : Optional Bool
        , destinations : List { provider : Text }
        , dir : Optional Text
        }

let runtime = Some { cache_dir = Some "./.cache/antora", fetch = Some True }

let content =
      let Language =
            { name : Text
            , branches : Optional (List Branch)
            , tags : Optional (List Text)
            }

      let SourceIn
          : Type
          = { languages : List Language, name : Text }

      let SourceOut
          : Type
          = { branches : Optional (List Text)
            , start_path : Optional Text
            , tags : Optional (List Text)
            , url : Text
            }

      let mkUrl
          : Text → Text
          =   λ(name : Text)
            → merge
                { Some = λ(dir : Text) → "${dir}/${name}.git"
                , None = "https://github.com/decidim/${name}.git"
                }
                reposDir

      let branch2text =
              λ(branch : Branch)
            → merge
                { Master =
                    merge
                      { Some = λ(_ : Text) → "HEAD", None = "master" }
                      reposDir
                , Other = λ(t : Text) → t
                }
                branch

      let addSource =
              λ(sourceName : Text)
            → λ(language : Language)
            → λ(list : List SourceOut)
            →   list
              # [ { url = mkUrl sourceName
                  , start_path = Some language.name
                  , branches =
                      merge
                        { Some =
                              λ(l : List Branch)
                            → Some (Prelude.List.map Branch Text branch2text l)
                        , None = None (List Text)
                        }
                        language.branches
                  , tags = language.tags
                  }
                ]

      let func
          : SourceIn → List SourceOut
          =   λ(s : SourceIn)
            → List/fold
                Language
                s.languages
                (List SourceOut)
                (addSource s.name)
                ([] : List SourceOut)

      in    { branches = branchesDefault }
          ⫽ { sources =
                Prelude.List.concat
                  SourceOut
                  (Prelude.List.map SourceIn (List SourceOut) func sources)
            }

in  { site, content, ui, asciidoc, runtime, output } : Playbook
