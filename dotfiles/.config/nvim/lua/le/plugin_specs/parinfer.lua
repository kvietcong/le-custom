local parinfer_filetypes = {
    "clojure",
    "scheme",
    "lisp",
    "racket",
    "hy",
    "fennel",
    "janet",
    "carp",
    "wast",
    "yuck",
    "dune",
}

local lazy_spec = {
    {
        "eraserhd/parinfer-rust",
        ft = parinfer_filetypes,
        build = "cargo build --release",
    },
}

return lazy_spec
