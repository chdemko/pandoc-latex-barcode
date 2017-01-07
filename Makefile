
SAMPLE=./pandoc_latex_barcode.sample
MD=$(SAMPLE).md
PDF=$(SAMPLE).pdf
TEX=$(SAMPLE).tex

FILTER=./pandoc_latex_barcode.py
TEMPLATE=./pandoc_latex_barcode.template.tex

DIST=dist

sdist: 
	python setup.py sdist

install: 
	python setup.py install	

pypi:
	twine upload $(DIST)/*

test: $(TEX) $(PDF) testpypi

%.tex: %.md
	pandoc --filter $(FILTER) --template $(TEMPLATE) --latex-engine xelatex $(MD) -o $(TEX)

%.pdf:  %.md
	pandoc --filter $(FILTER) --template $(TEMPLATE) --latex-engine xelatex $(MD) -o $(PDF)

testpypi: sdist 
	twine upload $(DIST)/* -r testpypi
	#mkvirtualenv test-pandoc-latex-barcode
	#workon test-pandoc-latex-barcode
	pip install --user -i https://testpypi.python.org/pypi pandoc-latex-barcode
	pip uninstall pandoc-latex-barcode
	#rmvirtualenv test-pandoc-latex-barcode

clean:
	rm -f $(PDF)
	rm -f $(TEX)
	rm -fr $(DIST)
