;; Fancy Start Screen
(local mini-starter (require :mini.starter))

(mini-starter.setup {
                     :header DashboardArt
                     :items [(mini-starter.sections.sessions 16 true)
                             (mini-starter.sections.recent_files 3)
                             mini-starter.sections.builtin_actions]})

mini-starter
