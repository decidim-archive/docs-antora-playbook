let Language = < en | es | ca >

let Language/equals
    : Language → Language → Bool
    = λ(l1 : Language) →
      λ(l2 : Language) →
        let isEn =
              λ(lang : Language) →
                merge { en = True, es = False, ca = False } lang

        let isEs =
              λ(lang : Language) →
                merge { en = False, es = True, ca = False } lang

        let isCa =
              λ(lang : Language) →
                merge { en = False, es = False, ca = True } lang

        in  isEn l1 && isEn l2 || isEs l1 && isEs l2 || isCa l1 && isCa l2

let Language/show =
      λ(lang : Language) → merge { ca = "ca", en = "en", es = "es" } lang

let Branch = < master | branch : Text >

let Branch/show =
      λ(branch : Branch) →
        merge { master = "master", branch = λ(t : Text) → t } branch

let Repository = { prefix : Text, name : Text }

let Source = { repository : Repository, branch : Branch, start_path : Text }

let ComponentVersionLanguage = { language : Language, source : Source }

let MultiLingualComponentVersion =
      { main : ComponentVersionLanguage
      , alternatives : List ComponentVersionLanguage
      }

in  { Language
    , Language/equals
    , Language/show
    , Branch
    , Branch/show
    , Repository
    , Source
    , ComponentVersionLanguage
    , MultiLingualComponentVersion
    }
