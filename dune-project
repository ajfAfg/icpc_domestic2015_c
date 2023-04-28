(lang dune 3.7)

(name icpc_domestic2015_c)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name icpc_domestic2015_c)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune menhir)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project

(using menhir 2.1)
