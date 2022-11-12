(local date (require :date))
(local etlua (require :etlua))

(local {: type-check! : get_is_falsy} (require :le.libf))

(λ ordinal-suffix [maybe-number]
  (type-check! [:string|number maybe-number])
  (let [number (match [(tonumber maybe-number)]
                 (where [a] a) a
                 _ (error (.. "Could not convert " maybe-number " to number")))
        last-digit (math.fmod number 10)
        last-two-digits (math.fmod number 100)]
    (.. number (match [last-digit last-two-digits]
                 (where [1 b] (not= b 11)) :st
                 (where [2 b] (not= b 12)) :nd
                 (where [3 b] (not= b 13)) :rd
                 _ :th))))

(λ get-aliases [the-date]
  (let [aliases [(the-date:fmt "%Y-W%V Review")]
        first-day-of-week (-> (the-date:copy)
                              (: :adddays (+ (- (the-date:getisoweekday)) 1)))]
    (icollect [_ i (range 0 6) :into aliases]
      (-> (first-day-of-week:copy)
          (: :adddays i)
          (: :fmt "\"%Y-%m-%d\"")))))

(local template (etlua.compile "
---
aliases:<% if get_is_falsy(aliases) then %> ~<% end %>
<% for _, alias in pairs(aliases) do -%>
- <%- alias %>
<% end -%>
created: <%- now:fmt('${le}') %>
edited: <%- now:fmt('${le}') %>
tags:
- Journal/Weekly
---

[[<%- last_week:fmt('%Y-W%V') %>|⏮]] | [[- My Journal -|📖]] | [[<%- next_week:fmt('%Y-W%V') %>|⏭]]

# <%- ordinal_suffix(the_date:fmt('%W')) %> Week of <%- the_date:fmt('%Y') %>
This is #TODO

## Monday

## Tuesday

## Wednesday

## Thursday

## Friday

## Saturday

## Sunday

"))

(λ get-weekly [?the-date]
  (local the-date (or ?the-date (date)))
  (pick-values 1 (-> (template {:the_date the-date
                                :now (date)
                                :aliases (get-aliases the-date)
                                :ordinal_suffix ordinal-suffix
                                :last_week (: (the-date:copy) :adddays (- 7))
                                :next_week (: (the-date:copy) :adddays 7)
                                : get_is_falsy})
                     (: :gsub "^\n" "")
                     (: :gsub "\n$" ""))))

get-weekly
