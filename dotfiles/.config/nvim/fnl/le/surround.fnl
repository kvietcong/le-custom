;; Surrounding Text Manipulation
(local mini-surround (require :mini.surround))

(mini-surround.setup {:custom_surroundings {:| {:output {:left "|" :right "|"}}}
                      :mappings {:add :ys
                                 :delete :ds
                                 :find :>S
                                 :find_left :<S
                                 :highlight ""
                                 :replace :cs
                                 :update_n_lines ""}})

mini-surround
