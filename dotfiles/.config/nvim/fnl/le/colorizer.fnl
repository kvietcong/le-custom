;; Color Highlight Previews
(local colorizer (require :colorizer))

(colorizer.setup ["*"] {:RGB false
                        :RRGGBB true
                        :names false
                        :RRGGBBAA false
                        :rgb_fn false
                        :hsl_fn false
                        :css false
                        :css_fn false
                        :mode :background})

colorizer
