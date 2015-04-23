cicm-paper.pdf : cicm-paper.tex cicm-paper.bbl
	pdflatex cicm-paper.tex && ( grep -s "Rerun to get" cicm-paper.log && pdflatex cicm-paper.tex || true )

cicm-paper.aux : cicm-paper.tex
	pdflatex cicm-paper.tex

cicm-paper.bbl : cicm-paper.aux bibfile.bib
	bibtex cicm-paper
