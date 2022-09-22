local M = {}

home = os.getenv("HOME")
project_root = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })

function M.setup()
	local config = {
		cmd = {
			home .. "/.sdks/jdk17/bin/java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xms1g",
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",

			"-jar",
			home
				.. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
			-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
			-- Must point to the                                                     Change this to
			-- eclipse.jdt.ls installation                                           the actual version

			"-configuration",
			home .. "/.local/share/nvim/mason/packages/jdtls/config_linux",
			-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
			-- Must point to the                      Change to one of `linux`, `win` or `mac`
			-- eclipse.jdt.ls installation            Depending on your system.

			-- See `data directory configuration` section in the README
			"-data",
			project_root .. "/.nvim-jdtls",
		},

		-- This is the default if not provided, you can remove it. Or adjust as needed.
		-- One dedicated LSP server & client will be started per unique root_dir
		root_dir = project_root,

		-- Here you can configure eclipse.jdt.ls specific settings
		-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		-- for a list of options
		settings = {
			java = {
				configuration = {
					-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
					-- And search for `interface RuntimeOption`
					-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
					runtimes = {
						{
							name = "jdk8",
							path = home .. "/.sdks/jdk8/",
						},
						{
							name = "jdk11",
							path = home .. "/.sdks/jdk11/",
						},
						{
							name = "jdk17",
							path = home .. "/.sdks/jdk17/",
						},
					},
				},
			},
		},

		-- Language server `initializationOptions`
		-- You need to extend the `bundles` with paths to jar files
		-- if you want to use additional eclipse.jdt.ls plugins.
		--
		-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
		--
		-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
		init_options = {
			bundles = {},
		},
	}
	-- This starts a new client & server,
	-- or attaches to an existing client & server depending on the `root_dir`.
	require("jdtls").start_or_attach(config)
end

return M
