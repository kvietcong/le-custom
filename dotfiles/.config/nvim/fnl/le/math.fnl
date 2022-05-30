;;; ========================
;;; == Le Math Module +/- ==
;;; ========================

(local {: type-check!} (require :le.libf))

(λ inc [x]
  (type-check! [:number x])
  (+ x 1))

(local ++ inc)

(λ dec [x]
  (type-check! [:number x])
  (- x 1))

(local -- dec)

(λ max [x y]
  (type-check! [:number x :number y])
  (if (<= y x) x y))

(λ min [x y]
  (type-check! [:number x :number y])
  (if (<= x y) x y))

(λ clamp [min# max# x]
  (type-check! [:number min# :number max# :number x])
  (max min# (min max# x)))

(λ inc-pos [pos inc-by]
  (type-check! [:table pos :number inc-by])
  [(. pos 1) (+ (. pos 2) inc-by)])

(λ dec-pos [pos dec-by]
  (type-check! [:table pos :number dec-by])
  [(. pos 1) (max 0 (- (. pos 2) dec-by))])

(λ int? [x]
  (type-check! [:number x])
  (= (% x 1) 0))

(λ natural? [x]
  (type-check! [:number x])
  (and (int? x) (< 0 x)))

(λ even? [x]
  (type-check! [int? x])
  (= (% x 2) 0))

(λ odd? [x]
  (not (even? x)))

(λ +? [x]
  (type-check! [:number x])
  (<= 0 x))

(λ -? [x]
  (type-check! [:number x])
  (<= x 0))

{: inc
 : ++
 : dec
 : --
 : max
 : min
 : clamp
 : inc-pos
 :inc_pos inc-pos
 : dec-pos
 :dec_pos dec-pos
 : int?
 :get_is_int int?
 : natural?
 :get_is_natural natural?
 : even?
 :get_is_even even?
 : odd?
 :get_is_odd odd?
 : +?
 :get_is_pos +?
 : -?
 :get_is_neg -?}
