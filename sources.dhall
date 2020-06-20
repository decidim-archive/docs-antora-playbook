let Antora = ./antora.dhall

let sources
    : List Antora.MultiLingualComponentVersion
    = [ { main =
          { language = Antora.Language.en
          , source =
            { repository =
              { prefix = "https://github.com/decidim/", name = "docs-base" }
            , branch = Antora.Branch.master
            , start_path = "en"
            }
          }
        , alternatives = [] : List Antora.ComponentVersionLanguage
        }
      , { main =
          { language = Antora.Language.en
          , source =
            { repository =
              { prefix = "https://github.com/decidim/"
              , name = "docs-publications"
              }
            , branch = Antora.Branch.master
            , start_path = "en"
            }
          }
        , alternatives =
          [ { language = Antora.Language.ca
            , source =
              { repository =
                { prefix = "https://github.com/decidim/"
                , name = "docs-publications"
                }
              , branch = Antora.Branch.master
              , start_path = "ca"
              }
            }
          , { language = Antora.Language.es
            , source =
              { repository =
                { prefix = "https://github.com/decidim/"
                , name = "docs-publications"
                }
              , branch = Antora.Branch.master
              , start_path = "es"
              }
            }
          ]
        }
      , { main =
          { language = Antora.Language.en
          , source =
            { repository =
              { prefix = "https://github.com/gmarpons/", name = "docs-test" }
            , branch = Antora.Branch.master
            , start_path = "en"
            }
          }
        , alternatives =
          [ { language = Antora.Language.ca
            , source =
              { repository =
                { prefix = "https://github.com/gmarpons/", name = "docs-test" }
              , branch = Antora.Branch.master
              , start_path = "ca"
              }
            }
          ]
        }
      , { main =
          { language = Antora.Language.en
          , source =
            { repository =
              { prefix = "https://github.com/gmarpons/", name = "docs-test" }
            , branch = Antora.Branch.branch "v1.0"
            , start_path = "en"
            }
          }
        , alternatives = [] : List Antora.ComponentVersionLanguage
        }
      , { main =
          { language = Antora.Language.en
          , source =
            { repository =
              { prefix = "https://github.com/decidim/"
              , name = "docs-features"
              }
            , branch = Antora.Branch.branch "revamp2020"
            , start_path = "en"
            }
          }
        , alternatives =
          [ { language = Antora.Language.ca
            , source =
              { repository =
                { prefix = "https://github.com/decidim/"
                , name = "docs-features"
                }
              , branch = Antora.Branch.branch "revamp2020"
              , start_path = "ca"
              }
            }
          , { language = Antora.Language.es
            , source =
              { repository =
                { prefix = "https://github.com/decidim/"
                , name = "docs-features"
                }
              , branch = Antora.Branch.branch "revamp2020"
              , start_path = "es"
              }
            }
          ]
        }
      , { main =
          { language = Antora.Language.en
          , source =
            { repository =
              { prefix = "https://github.com/decidim/"
              , name = "docs-social-contract"
              }
            , branch = Antora.Branch.branch "revamp2020"
            , start_path = "en"
            }
          }
        , alternatives =
          [ { language = Antora.Language.ca
            , source =
              { repository =
                { prefix = "https://github.com/decidim/"
                , name = "docs-social-contract"
                }
              , branch = Antora.Branch.branch "revamp2020"
              , start_path = "ca"
              }
            }
          , { language = Antora.Language.es
            , source =
              { repository =
                { prefix = "https://github.com/decidim/"
                , name = "docs-social-contract"
                }
              , branch = Antora.Branch.branch "revamp2020"
              , start_path = "es"
              }
            }
          ]
        }
      ]

in sources
