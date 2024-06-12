all: clean install

install:
	stow --verbose --target=$$HOME */

clean:
	stow --verbose --target=$$HOME --delete */
