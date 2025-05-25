local mason_registry = require 'mason-registry'
local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
return {
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue', 'typescript', 'javascript' },
      },
    },
  },
  filetypes = {
    'typescript',
    'typescriptreact',
    'javascript',
    'javascriptreact',
    'vue',
  },
}
