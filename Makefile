all: \
	plot.pdf \
	plot_colored.pdf

plot.pdf: plot.tex dat
	latexmk -pdf -lualatex $<

plot_colored.pdf: plot_colored.tex dat
	latexmk -pdf -lualatex $<

dat: ./zig-out/bin/humidity
	$< > $@

./zig-out/bin/humidity: ./src/main.zig
	zig build

.PHONY: clean distclean

clean:
	latexmk -CA
	-rm -rf .zig-cache
	-rm -rf dat

distclean: clean
	-rm -rf plot.pdf
	-rm -rf plot_colored.pdf
	-rm -rf zig-out
	-rm -rf humidity.x
