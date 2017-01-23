include(UseLATEX)

add_latex_document (
    szakdolgozat.tex
    INPUTS kotestabla.tex bib/cites.bib
    IMAGE_DIRS img
    BIBFILES bib/cites.bib bib/huplain.bst
)
