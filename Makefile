.PHONY: clean

clean: ## 删除 .venv 与常见构建/缓存产物（等价于 uvx pypurge --yes --clean-venv .）
	uvx pypurge --yes --clean-venv .
