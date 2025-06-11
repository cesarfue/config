return {
	"mfussenegger/nvim-jdtls",
	dependencies = { "williamboman/mason.nvim" },
	ft = "java", -- Only load for Java files
	config = function()
		local jdtls = require("jdtls")

		-- Get Mason path
		local mason_path = vim.fn.stdpath("data") .. "/mason"

		local config = {
			cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
				"-configuration",
				mason_path .. "/packages/jdtls/config_mac", -- Change to config_linux if on Linux
				"-data",
				vim.fn.expand("~/.cache/jdtls-workspace/") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
			},
			root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
		}

		jdtls.start_or_attach(config)
	end,
}
