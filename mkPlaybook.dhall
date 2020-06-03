let Prelude = https://prelude.dhall-lang.org/package.dhall

let Antora = ./antora.dhall

let Playbook = ./antora-playbook-schema.dhall

let sources = ./sources.dhall

let sources/check_no_repeated_languages =
        assert
      :   Prelude.List.all
            Antora.MultiLingualComponentVersion
            ( λ(mlcv : Antora.MultiLingualComponentVersion) →
                Prelude.List.all
                  Antora.ComponentVersionLanguage
                  ( λ(cvl : Antora.ComponentVersionLanguage) →
                      Prelude.Bool.not
                        (Antora.Language/equals mlcv.main.language cvl.language)
                  )
                  mlcv.alternatives
            )
            sources
        ≡ True

let PlaybookType = < local : Text | remote >

let site =
      λ(pt : PlaybookType) →
      λ(lang : Antora.Language) →
        { title = "Decidim Docs"
        , url =
            merge
              { local =
                  λ(_ : Text) →
                    "http://localhost:5500/build/site/${Antora.Language/show
                                                          lang}"
              , remote = "https://docs.decidim.org/${Antora.Language/show lang}"
              }
              pt
        , start_page = Some "decidim:ROOT:index.adoc"
        , keys = None (Prelude.Map.Type Text Text)
        , robots = None Playbook.Robots
        }

let ui =
      λ(pt : PlaybookType) →
        { bundle =
          { snapshot = Some True
          , start_path = None Text
          , url =
              merge
                { local =
                    λ(dir : Text) →
                      "${dir}/docs-ui-antora.git/build/ui-bundle.zip"
                , remote =
                    "https://gitlab.com/antora/antora-ui-default/-/jobs/artifacts/master/raw/build/ui-bundle.zip?job=bundle-stable"
                }
                pt
          }
        , default_layout = None Text
        , output_dir = None Text
        , supplemental_files = Some "./supplemental_ui"
        }

let asciidoc =
      λ(lang : Antora.Language) →
        Some
          { attributes = Some
            [ { mapKey = "idseparator", mapValue = "-" }
            , { mapKey = "xrefstyle", mapValue = "short" }
            , { mapKey = "idprefix", mapValue = "" }
            , { mapKey = "page-playbook-lang"
              , mapValue = "${Antora.Language/show lang}"
              }
            ]
          , extensions = None (List Text)
          }

let output =
      λ(lang : Antora.Language) →
        Some
          { clean = None Bool
          , destinations = [] : List { provider : Text }
          , dir = Some "build/site/${Antora.Language/show lang}"
          }

let runtime = Some { cache_dir = Some "./.cache/antora", fetch = Some True }

let mkPlaybookSource
    : PlaybookType → Antora.Source → Playbook.Source
    = λ(pt : PlaybookType) →
      λ(s : Antora.Source) →
        { url =
            merge
              { local = λ(dir : Text) → "${dir}/${s.repository.name}.git"
              , remote = s.repository.prefix ++ s.repository.name
              }
              pt
        , branches = Some
          [ merge
              { master =
                  merge
                    { local = λ(_ : Text) → "HEAD"
                    , remote = Antora.Branch/show s.branch
                    }
                    pt
              , branch = λ(b : Text) → b
              }
              s.branch
          ]
        , tags = None (List Text)
        , start_path = Some s.start_path
        }

let mkPlaybookSources
    : PlaybookType → Antora.Language → List Playbook.Source
    = λ(pt : PlaybookType) →
      λ(l : Antora.Language) →
        Prelude.List.concatMap
          Antora.MultiLingualComponentVersion
          Playbook.Source
          ( λ(x : Antora.MultiLingualComponentVersion) →
              let o_alt =
                    Prelude.List.head
                      Antora.ComponentVersionLanguage
                      ( Prelude.List.filter
                          Antora.ComponentVersionLanguage
                          ( λ(cvl : Antora.ComponentVersionLanguage) →
                              Antora.Language/equals l cvl.language
                          )
                          x.alternatives
                      )

              in  merge
                    { None = [ mkPlaybookSource pt x.main.source ]
                    , Some =
                        λ(alt : Antora.ComponentVersionLanguage) →
                          [ mkPlaybookSource pt alt.source
                          , mkPlaybookSource
                              PlaybookType.remote
                              (   alt.source
                                ⫽ { branch =
                                      Antora.Branch.branch
                                        (     Antora.Branch/show
                                                alt.source.branch
                                          ++  ".NT"
                                        )
                                  }
                              )
                          ]
                    }
                    o_alt
          )
          sources

let content =
      λ(pt : PlaybookType) →
      λ(lang : Antora.Language) →
        { branches = None (List Text)
        , tags = None (List Text)
        , edit_url = None Text
        , sources = mkPlaybookSources pt lang
        }

let mkPlaybook
    : PlaybookType → Antora.Language → Playbook.Playbook
    = λ(pt : PlaybookType) →
      λ(lang : Antora.Language) →
        { content = content pt lang
        , site = site pt lang
        , ui = ui pt
        , asciidoc = asciidoc lang
        , output = output lang
        , runtime
        , urls = None { redirect_facility : Playbook.RedirectFacility }
        }

in  { EN = Antora.Language.en
    , CA = Antora.Language.ca
    , ES = Antora.Language.es
    , LOCAL = PlaybookType.local
    , REMOTE = PlaybookType.remote
    , mkPlaybook
    }
