set(LATEX_DEFAULT_BUILD safepdf)
set(PS2PDF_CONVERTER ps2pdf)
include(UseLATEX)

add_latex_document (
    szakdolgozat.tex
    INPUTS kotestabla.tex bib/cites.bib
    IMAGE_DIRS eps img
    BIBFILES bib/cites.bib bib/huplain.bst
    DEPENDS ${THESIS_DEPENDENCIES}
)

add_latex_document (
    kotestabla.tex
    TARGET_NAME frontpage
)
