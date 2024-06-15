(λ config []
  (local oil (require :oil))
  (oil.setup {:keymaps {:g? :actions.show_help
                        :<Enter> :actions.select
                        :<C-s> :actions.select_vsplit
                        :<C-h> :actions.select_split
                        :<C-p> :actions.preview
                        :<C-t> :actions.close
                        :<C-c> :actions.close
                        :<C-l> :actions.refresh
                        :- :actions.parent
                        :<C-o> :actions.parent
                        :_ :actions.open_cwd
                        :<C-i> :actions.open_cwd
                        "`" :actions.cd
                        "~" :actions.tcd
                        :g. :actions.toggle_hidden}
              :view_options {:show_hidden true}})
  (vim.keymap.set [:n] "<C-f>" oil.toggle_float {:desc "Toggle oil"}))

(local keys [[:<C-f>]])

(local lazy-spec [{1 "stevearc/oil.nvim"
                   : config
                   : keys}])

lazy-spec
