.PHONY: clean

clean:
	uvx pypurge --yes --clean-venv .
	rm -f uv.lock
