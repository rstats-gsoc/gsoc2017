figure-projects.png: figure-projects.R projects.csv
	R --no-save < $<
