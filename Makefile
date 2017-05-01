HOCKING-RGSOC.pdf: HOCKING-RGSOC.tex figure-projects.png
	pdflatex HOCKING-RGSOC
figure-projects.png: figure-projects.R projects.csv
	R --no-save < $<
